import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ev_products_app/core/environment/environments.dart';
import 'package:ev_products_app/core/l10n/app_localizations.dart';
import 'package:ev_products_app/core/network/connectivity_cubit.dart';
import 'package:ev_products_app/core/utils/height_util.dart';
import 'package:ev_products_app/feature/products/domain/entities/category.dart';
import 'package:ev_products_app/feature/products/domain/entities/product.dart';
import 'package:ev_products_app/feature/products/presentation/cubits/products_cubit.dart';
import 'package:ev_products_app/feature/products/presentation/cubits/products_state.dart';
import 'package:ev_products_app/feature/shared/snack_bar/snack_bar_custom.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  static const int _initialPage = 10000;

  late final PageController _pageController;
  late final ScrollController _scrollController;
  late final Timer _autoPlayTimer;
  late final AnimationController _marqueeController;
  double _currentPage = _initialPage.toDouble();
  int _productsCount = 0;
  bool _isLoadingMoreProducts = false;

  @override
  void initState() {
    super.initState();

    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();

    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.86,
    );
    _pageController.addListener(_onPageChanged);

    _scrollController = ScrollController()..addListener(_onMainScroll);

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients || _productsCount < 2) {
        return;
      }

      final currentPage = (_pageController.page ?? _currentPage).round();
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer.cancel();
    _marqueeController.dispose();
    _scrollController
      ..removeListener(_onMainScroll)
      ..dispose();
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page;
    if (page == null || !mounted) {
      return;
    }

    setState(() {
      _currentPage = page;
    });
  }

  int _carouselIndex(int pageIndex, int length) {
    if (length == 0) {
      return 0;
    }
    return ((pageIndex % length) + length) % length;
  }

  void _onMainScroll() {
    if (!_scrollController.hasClients || _isLoadingMoreProducts) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 250;
    if (_scrollController.position.pixels < threshold) {
      return;
    }

    unawaited(_loadMoreProducts());
  }

  Future<void> _loadMoreProducts() async {
    final productsCubit = context.read<ProductsCubit>();
    if (!productsCubit.hasMoreProducts || productsCubit.isLoadingMore) {
      return;
    }

    setState(() {
      _isLoadingMoreProducts = true;
    });

    await productsCubit.loadMore();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoadingMoreProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 86,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                SnackbarCustom(
                  context,
                ).showInfo(l10n.notificationSectionInBuilding);
              },
              child: Badge(
                backgroundColor: theme.colorScheme.primary,
                label: Text('3'),
                child: const Icon(Icons.notifications_rounded),
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.searchProducts,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: BlocListener<ConnectivityCubit, ConnectivityStatus>(
        listener: (context, status) {
          if (status == ConnectivityStatus.online) {
            context.read<ProductsCubit>().load(limit: 10, offset: 1);
          }
        },
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (featuredProducts, products, categories) =>
                  _buildProducts(
                    context,
                    featuredProducts,
                    products,
                    categories,
                  ),
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ImagePaths.errorCachedProducts,
                        height: HeightUtil.getHeightDevice(context, 150),
                      ),
                      Text(
                        l10n.emptyCachedProducts,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<ProductsCubit>().load(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
              detailLoaded: (product) => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProducts(
    BuildContext context,
    List<Product> featuredProducts,
    List<Product> products,
    List<Category> categories,
  ) {
    if (featuredProducts.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    _productsCount = featuredProducts.length;

    final theme = Theme.of(context);
    final selectedIndex = _carouselIndex(
      _currentPage.round(),
      featuredProducts.length,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 1.0),
            theme.canvasColor,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 130),
              Image.asset(
                ImagePaths.bannerTennis,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ClipRect(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      return AnimatedBuilder(
                        animation: _marqueeController,
                        child: Image.asset(
                          ImagePaths.bannerDiscountsApp,
                          width: width,
                        ),
                        builder: (context, child) {
                          final dx = width * _marqueeController.value;

                          return Stack(
                            children: [
                              Transform.translate(
                                offset: Offset(dx, 0),
                                child: child,
                              ),
                              Transform.translate(
                                offset: Offset(dx - width, 0),
                                child: child,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final product =
                        featuredProducts[_carouselIndex(
                          index,
                          featuredProducts.length,
                        )];
                    final distance = (_currentPage - index).abs();
                    final scale = (1 - (distance * 0.08)).clamp(0.9, 1.0);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: distance < 0.5 ? 0 : 12,
                      ),
                      child: Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTap: () => context.pushNamed(
                            'detail',
                            pathParameters: {
                              'productId': product.id.toString(),
                            },
                          ),
                          child: _FeaturedProductPreview(product: product),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(featuredProducts.length, (index) {
                  final selected = index == selectedIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selected ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              _buildListCategories(context, categories),
              _buildListProducts(context, products),
              if (_isLoadingMoreProducts)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (!context.read<ProductsCubit>().hasMoreProducts)
                const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListProducts(BuildContext context, List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductGridCard(product: product);
      },
    );
  }

  Widget _buildListCategories(BuildContext context, List<Category> categories) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((category) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: HeightUtil.getHeightDevice(context, 8),
              vertical: 12,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: category.image,
                    width: HeightUtil.getHeightDevice(context, 64),
                    height: HeightUtil.getHeightDevice(context, 64),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Container(
                        width: HeightUtil.getHeightDevice(context, 64),
                        height: HeightUtil.getHeightDevice(context, 64),
                        color: Colors.grey.withValues(alpha: 0.24),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 28,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.pricediscount != null;
    final image = product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '';

    return GestureDetector(
      onTap: () => context.pushNamed(
        'detail',
        pathParameters: {'productId': product.id.toString()},
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: image.isEmpty
                    ? Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_outlined),
                      )
                    : CachedNetworkImage(
                        imageUrl: image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                            ),
                          );
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (hasDiscount)
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  Text(
                    '\$${(product.pricediscount ?? product.price).toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProductPreview extends StatelessWidget {
  const _FeaturedProductPreview({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 250,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: product.imagesUrl[0],
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                  ),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: -44,
              child: Transform.rotate(
                angle: 0.785398, // 45 degrees
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3,
                          decorationColor: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${product.pricediscount?.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
