import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme_constants.dart';
import 'package:plant_app/bloc/map_page.dart';
import 'package:plant_app/bloc/home_page_camera.dart';
import 'package:plant_app/bloc/camera_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderWithSearchBox extends StatefulWidget {
  const HeaderWithSearchBox({super.key, required this.size});

  final Size size;

  @override
  State<HeaderWithSearchBox> createState() => _HeaderWithSearchBoxState();
}

class _HeaderWithSearchBoxState extends State<HeaderWithSearchBox> {
  String? alamatDipilih;

  Future<void> _pilihAlamat(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );

    if (result != null && mounted) {
      setState(() {
        alamatDipilih = result as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.kDefaultPadding * 2.5),
        height: widget.size.height * 0.2,
        child: Stack(
          children: <Widget>[
            // Background header
            Container(
              padding: EdgeInsets.only(
                left: AppSpacing.kDefaultPadding,
                right: AppSpacing.kDefaultPadding,
                bottom: 36 + AppSpacing.kDefaultPadding,
              ),
              height: widget.size.height * 0.2 - 27,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.kPrimaryColor, AppColors.kPrimaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'Hi Uishopy!',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      BlocBuilder<CameraBloc, CameraState>(
                        builder: (context, state) {
                          Widget imageWidget = Image.asset(
                            "assets/images/logo.png",
                            height: 40,
                          );

                          if (state is CameraReady && state.imageFile != null) {
                            imageWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                state.imageFile!,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BlocProvider.value(
                                        value: context.read<CameraBloc>(),
                                        child: const HomePage(),
                                      ),
                                ),
                              );
                            },
                            child: imageWidget,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Pilih alamat
                  InkWell(
                    onTap: () => _pilihAlamat(context),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alamatDipilih ?? 'Pilih alamat di sini',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.map_outlined, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Box
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  horizontal: AppSpacing.kDefaultPadding,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.kDefaultPadding,
                ),
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 50,
                      color: AppColors.kPrimaryColor.withOpacity(0.23),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: AppColors.kPrimaryColor.withOpacity(0.5),
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SvgPicture.asset("assets/icons/search.svg"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
