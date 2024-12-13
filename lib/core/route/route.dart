import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/contact/presentation/pages/add_contact_view.dart';
import '../../features/contact/presentation/pages/contact_details_view.dart';
import '../../features/contact/presentation/pages/contact_list_page.dart';
import '../../features/contact/presentation/pages/edit_contact_view.dart';
import '../../features/gold_price/presentation/pages/change_gold_price_view.dart';
import '../../features/gold_price/presentation/pages/gold_price_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/order/presentation/pages/check_order_view.dart';
import '../../features/order/presentation/pages/create_order_view.dart';
import '../../features/order/presentation/pages/exchange_gold_view.dart';
import '../../features/qr_scan/presentation/pages/qr_scan_view.dart';
import '../../features/settings/presentation/pages/change_access_info_page.dart';
import '../../features/settings/presentation/pages/change_password_page.dart';
import '../../features/settings/presentation/pages/change_profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../common/animations/page_transition.dart';
import '../common/cubits/app_user/app_user_cubit.dart';
import '../common/widgets/nav_bar/nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorAuthenticationKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAuthentication');

final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorGoldPriceKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellGoldPrice');
final _shellNavigatorContactListKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellContactList');
final _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

List<String> mainRoute = [
  '/HomePage',
  '/GoldPricePage',
  '/ContactListPage',
  '/SettingsPage'
];

final routers = GoRouter(
  initialLocation: '/HomePage',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return mainRoute.contains(state.uri.toString())
            ? ScaffoldWithNestedNavigation(
                navigationShell: navigationShell, uri: state.uri.toString())
            : ScaffoldWithoutNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/HomePage',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
              routes: [
                GoRoute(
                    path: 'CreateOrderPage',
                    pageBuilder: (context, state) {
                      return pageTransition(
                          page: const CreateOrderPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .animate(animation),
                              child: child,
                            );
                          });
                    },
                    routes: [
                      GoRoute(
                        path: 'QRScanPage',
                        builder: (context, state) {
                          return const QrScanPage();
                        },
                      )
                    ]),
                GoRoute(
                  path: 'ExchangeGoldPage',
                  builder: (context, state) {
                    return const ExchangeGoldPage();
                  },
                ),
                GoRoute(
                  path: 'CheckOrderPage',
                  builder: (context, state) {
                    return const CheckOrderPage();
                  },
                ),
                GoRoute(
                  path: 'ChangeGoldPricePage',
                  pageBuilder: (context, state) {
                    return pageTransition(
                        page: const ChangeGoldPricePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(animation),
                            child: child,
                          );
                        });
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorGoldPriceKey,
          routes: [
            GoRoute(
              path: '/GoldPricePage',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: GoldPricePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorContactListKey,
          routes: [
            GoRoute(
                path: '/ContactListPage',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: ContactListPage(),
                    ),
                routes: [
                  GoRoute(
                    path: "AddContactPage",
                    pageBuilder: (context, state) {
                      return pageTransition(
                          page: const AddContactPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: Offset.zero)
                                  .animate(animation),
                              child: child,
                            );
                          });
                    },
                  ),
                  GoRoute(
                      path: "ContactDetailsPage",
                      pageBuilder: (context, state) {
                        return pageTransition(
                            page: const ContactDetailsPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero)
                                    .animate(animation),
                                child: child,
                              );
                            });
                      },
                      routes: [
                        GoRoute(
                          path: "EditContactPage",
                          pageBuilder: (context, state) {
                            return pageTransition(
                                page: const EditContactPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero)
                                        .animate(animation),
                                    child: child,
                                  );
                                });
                          },
                        ),
                      ]),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
                path: '/SettingsPage',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: SettingsPage(),
                    ),
                routes: [
                  GoRoute(
                    path: "ChangeProfilePage",
                    pageBuilder: (context, state) {
                      return pageTransition(
                          page: const ChangeProfilePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .animate(animation),
                              child: child,
                            );
                          });
                    },
                  ),
                  GoRoute(
                    path: "ChangePasswordPage",
                    pageBuilder: (context, state) {
                      return pageTransition(
                          page: const ChangePasswordPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .animate(animation),
                              child: child,
                            );
                          });
                    },
                  ),
                  GoRoute(
                    path: "ChangeAccessInformationPage",
                    pageBuilder: (context, state) {
                      return pageTransition(
                          page: const ChangeAccessInformationPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero)
                                  .animate(animation),
                              child: child,
                            );
                          });
                    },
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAuthenticationKey,
          routes: [
            GoRoute(
              path: '/WelcomePage',
              pageBuilder: (context, state) {
                return pageTransition(
                    page: const WelcomePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(1, 0), end: Offset.zero)
                            .animate(animation),
                        child: child,
                      );
                    });
              },
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = context.read<AppUserCubit>().state is AppUserLoggedIn;
    final isLoggingIn = state.matchedLocation == '/WelcomePage';

    if (!isLoggedIn && !isLoggingIn) return '/WelcomePage';
    if (isLoggedIn && isLoggingIn) return '/HomePage';

    return null;
  },
);
