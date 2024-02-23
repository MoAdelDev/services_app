import 'package:cached_network_image/cached_network_image.dart';
import 'package:entertainment_services/add/service_model.dart';
import 'package:entertainment_services/core/data/app_data.dart';
import 'package:entertainment_services/core/widgets/default_progress_indicator.dart';
import 'package:entertainment_services/services/cubit/cubit/services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesScreen extends StatelessWidget {
  final String id;
  const ServicesScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesCubit()..getServices(id),
      child: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          ServicesCubit cubit = context.read<ServicesCubit>();
          if (state is ServicesLoading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: DefaultProgressIndicator(),
              ),
            );
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(cubit.categoryTitle),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'بحث',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          cubit.getServices(id);
                        } else {
                          cubit.searchServiceByTitleOrAddress(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        ServiceModel service =
                            context.read<ServicesCubit>().services[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: service.image,
                                    width: double.infinity,
                                    height: 250.0,
                                    placeholder: (context, url) => const Center(
                                      child: DefaultProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (userModel?.type == 'Admin')
                                    IconButton(
                                      onPressed: () =>
                                          cubit.deleteService(service.id),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                service.title,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                service.description,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () => cubit.openMap(
                                    service.latitude, service.longitude),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.redAccent,
                                    ),
                                    Expanded(
                                      child: Text(
                                        service.address,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10.0,
                      ),
                      itemCount: cubit.services.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
