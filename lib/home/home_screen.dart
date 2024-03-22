import 'package:entertainment_services/add/add_screen.dart';
import 'package:entertainment_services/core/data/app_data.dart';
import 'package:entertainment_services/core/widgets/default_progress_indicator.dart';
import 'package:entertainment_services/home/cubit/home_cubit.dart';
import 'package:entertainment_services/home/cubit/home_state.dart';
import 'package:entertainment_services/login/login_screen.dart';
import 'package:entertainment_services/services/services_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit()..getUser(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeError) {
              return const Scaffold(
                body: Center(
                  child: DefaultProgressIndicator(),
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('الصفحة الرئيسية'),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/service.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'اهلاً ${userModel?.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text('الأماكن الترفيهية'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServicesScreen(
                            id: '1',
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('المرافق العامة'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServicesScreen(
                            id: '2',
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('المصالح الحكومية'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServicesScreen(
                            id: '3',
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          userModel = null;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false);
                        });
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: userModel?.type == 'Admin'
                  ? FloatingActionButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddScreen(),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    )
                  : null,
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.asset('assets/images/home.jpg'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CategoryCard(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ServicesScreen(
                                      id: '1',
                                    ),
                                  ),
                                ),
                                iconData: Icons.restaurant_menu,
                                text: 'الأماكن الترفيهية',
                              ),
                            ),
                            Expanded(
                              child: CategoryCard(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ServicesScreen(
                                      id: '2',
                                    ),
                                  ),
                                ),
                                iconData: Icons.home,
                                text: 'المصالح العامة',
                              ),
                            ),
                          ],
                        ),
                        CategoryCard(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ServicesScreen(
                                id: '3',
                              ),
                            ),
                          ),
                          iconData: Icons.book,
                          text: 'المرافق العامة',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  const CategoryCard(
      {super.key,
      required this.iconData,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 100,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  size: 50.0,
                  color: Colors.redAccent,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
