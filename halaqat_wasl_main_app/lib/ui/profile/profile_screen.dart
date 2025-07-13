import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_main_app/shared/set_up.dart';
import 'package:halaqat_wasl_main_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_main_app/theme/app_colors.dart';
import 'package:halaqat_wasl_main_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_main_app/ui/edit_profile/edit_profile_screen.dart';
import 'package:halaqat_wasl_main_app/ui/profile/bloc/profile_bloc.dart';
import 'package:halaqat_wasl_main_app/ui/profile/widgets/profile_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      // Create the Bloc and add initial event to load profile data
      create: (context) => ProfileBloc()..add(ProfileDataLoadRequested()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 16.0, bottom: 75.0),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App logo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 150,
                    ),

                    // Card containing profile content
                    Expanded(
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 32.0,
                          bottom: 32.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is ProfileData) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            tr('profile_screen.profile'),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.sfProBold24,
                                          ),
                                        ),

                                        // Navigate to Edit Profile screen
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfileScreen(),
                                              ),
                                            );
                                          },
                                          icon: Icon(LucideIcons.edit),
                                        ),
                                      ],
                                    ),

                                    // List view showing profile data items
                                    Expanded(
                                      child: ListView(
                                        primary: false,
                                        children: [
                                          ProfileItemWidget(
                                            item: ProfileItem(
                                              hintText: state.data.fullName,
                                              icon: 'assets/icons/account.png',
                                            ),
                                          ),
                                          ProfileItemWidget(
                                            item: ProfileItem(
                                              hintText: state.data.email,
                                              icon: 'assets/icons/email.png',
                                            ),
                                          ),
                                          ProfileItemWidget(
                                            item: ProfileItem(
                                              hintText: state.data.phoneNumber,
                                              icon: 'assets/icons/call.png',
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              // Handle language selection
                                              context.locale.languageCode ==
                                                      'en'
                                                  ? await context.setLocale(
                                                      Locale('ar', 'AR'),
                                                    )
                                                  : await context.setLocale(
                                                      Locale('en', 'US'),
                                                    );
                                            },
                                            child: ProfileItemWidget(
                                              item: ProfileItem(
                                                hintText: tr(
                                                  'profile_screen.arabic',
                                                ),
                                                icon:
                                                    'assets/icons/language.png',
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Handle support email tap
                                              final Uri emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path: 'Support@gmail.com',
                                              );

                                              // Launch email client
                                              launchUrl(emailLaunchUri);
                                            },
                                            child: ProfileItemWidget(
                                              item: ProfileItem(
                                                hintText: 'Support@gmail.com',
                                                icon:
                                                    'assets/icons/support.png',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Logout button
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 16,
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          SetupSupabase
                                              .sharedSupabase
                                              .client
                                              .auth
                                              .signOut();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.cancelButtonColor,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.all(16.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.logout),
                                            Gap.gapW16,
                                            Text(
                                              tr('profile_screen.logout'),
                                              style: AppTextStyle.sfProBold16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                                // Loading state - show loading spinner
                              } else if (state is ProfileLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );

                                // Error state - show error message
                              } else if (state is ProfileError) {
                                return Center(child: Text(state.message));

                                // Unknown state - show empty container
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
