import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';

class BannerCarouselWidget extends StatefulWidget {
  final List<String> bannerImages;
  final void Function(int)? onBannerTap;
  
  const BannerCarouselWidget({
    super.key,
    this.bannerImages = const [
      ImageAssets.homeBanner,
    ],
    this.onBannerTap,
  });

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  final currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          CarouselSlider(
            items: widget.bannerImages.map((imagePath) {
              return GestureDetector(
                onTap: () {
                  if (widget.onBannerTap != null) {
                    widget.onBannerTap!(currentIndex.value);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 190,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 190,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: Image.asset(
                        ImageAssets.homeBanner,
                        width: double.infinity,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 190,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                currentIndex.value = index;
              },
            ),
          ),
          // const SizedBox(height: 10),
          // ValueListenableBuilder<int>(
          //   valueListenable: currentIndex,
          //   builder: (context, index, child) {
          //     return Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: widget.bannerImages.map((image) {
          //         int currentPosition = widget.bannerImages.indexOf(image);
          //         return Container(
          //           width: currentPosition == index ? 16.0 : 6.0,
          //           height: 6.0,
          //           margin: const EdgeInsets.symmetric(horizontal: 3.0),
          //           decoration: BoxDecoration(
          //             shape: BoxShape.rectangle,
          //             borderRadius: BorderRadius.circular(3.0),
          //             color: currentPosition == index 
          //                 ? Colors.blueAccent 
          //                 : Colors.grey.withValues(alpha: 0.5),
          //           ),
          //         );
          //       }).toList(),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
