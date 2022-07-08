import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nativ/bloc/profile/profile_bloc.dart';
import 'package:nativ/view/pages/connect_page.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileMenu());

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileBloc>(),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileLoaded) {
              return ListView(
                shrinkWrap: true,
                children: [
                  // * Header Image
                  AspectRatio(
                    aspectRatio: 1.91 / 1,
                    child: Image.network(
                      'https://static.euronews.com/articles/stories/06/25/84/50/1200x675_cmsv2_f71b6679-918e-5672-8b87-8f3e17af759e-6258450.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // * Main Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            MainProfileInfo(
                                name: state.user.name!,
                                location: state.user.location!,
                                bio: state.user.bio!),
                            const Padding(
                              padding: EdgeInsets.only(right: 18),
                              child: ProfileIcon(),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: PublicReviews(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: MySpecialties(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: MyTrips(),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Something Went Wrong...'),
              );
            }
          },
        ),
      ),
    );
  }
}

class PublicReviews extends StatelessWidget {
  const PublicReviews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
        widthFactor: 0.90, child: ReviewCarousel());
  }
}

class MySpecialties extends StatelessWidget {
  const MySpecialties({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const CircularProgressIndicator();
        }
        if (state is ProfileLoaded) {
          return Container(
            //    transformAlignment: Alignment.center,
            alignment: Alignment.center,

            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'My Specialties',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Wrap(spacing: 10,
                        // crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Chip(
                            label: Text(state.user.specialties![1]),
                            avatar: const Icon(
                              FontAwesomeIcons.utensils,
                              size: 20,
                            ),
                          ),
                          Chip(
                            label: Text(state.user.specialties![2]),
                            avatar: const Icon(
                              FontAwesomeIcons.masksTheater,
                              size: 20,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}

class MyTrips extends StatelessWidget {
  const MyTrips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const CircularProgressIndicator();
        }
        if (state is ProfileLoaded) {
          return Container(
            color: Colors.black38,
            child: Container(
              //    transformAlignment: Alignment.center,
              alignment: Alignment.center,

              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Places I\'ve traveled:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Wrap(spacing: 10,
                          //crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Chip(
                              label: Text(state.user.visitedPlaces![0]),
                              avatar: const Icon(
                                FontAwesomeIcons.earthAmericas,
                                size: 20,
                              ),
                            ),
                            Chip(
                              label: Text(state.user.visitedPlaces![1]),
                              avatar: const Icon(
                                FontAwesomeIcons.earthEurope,
                                size: 20,
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}

class SpecialtyIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  const SpecialtyIcon({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReviewCarousel extends StatelessWidget {
  const ReviewCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: const [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://bustickets.com/wp-content/uploads/2019/09/solo-travel-backpack-tips.jpg'),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
                '“Thorin is the BEST nativ around. He took us to incredible & authentic restaurants & guided an awesome hike.” \n -Jane Walenda, Traveler'),
          )
        ]),
      ),
    );
  }
}

class MainProfileInfo extends StatelessWidget {
  final String name, bio, location;
  const MainProfileInfo({
    required this.name,
    required this.bio,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      //leading: ProfileIcon(),
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 14,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Icon(
            Icons.check_circle_rounded,
            size: 20,
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 14,
                  children: [
                    const Icon(
                      FontAwesomeIcons.mapLocation,
                      size: 15,
                    ),
                    Text(location),
                  ],
                ),
                const SizedBox(
                  height: 30,
                  child: FittedBox(
                    child: Chip(
                      backgroundColor: Colors.orange,
                      label: Text(
                        'Top Rated',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                )
              ]),
          const SizedBox(
            height: 10,
          ),
          Text(
            bio,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ConnectPage());
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      fixedSize:
                          MaterialStateProperty.all(const Size(360, 42))),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: const [
                      Text(
                        'Connect ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        FontAwesomeIcons.connectdevelop,
                      )
                    ],
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionChip(
                label: const Text(
                  'Message Me',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
                avatar: const Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(
                child: Wrap(spacing: 20, children: const [
                  Icon(
                    FontAwesomeIcons.instagram,
                  ),
                  Icon(
                    FontAwesomeIcons.facebook,
                  ),
                  Icon(
                    FontAwesomeIcons.twitter,
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 30.0,
      backgroundImage: NetworkImage(
        'https://www.zbrushcentral.com/uploads/default/original/4X/7/9/6/7966865da1c1203fd5250ab05bb1fc00ba8133e9.jpeg',
      ),
    );
  }
}
