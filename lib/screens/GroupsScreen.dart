import 'package:chama/utils/constants.dart';
import 'package:chama/utils/toast_util.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  bool isDark = false;
  bool isRoscas = false;
  List<String> images = [
    "https://i.imgur.com/CzXTtJV.jpg",
    "https://i.imgur.com/OB0y6MR.jpg",
    "https://farm2.staticflickr.com/1533/26541536141_41abe98db3_z_d.jpg",
    "https://farm4.staticflickr.com/3075/3168662394_7d7103de7d_z_d.jpg",
    "https://farm9.staticflickr.com/8505/8441256181_4e98d8bff5_z_d.jpg",
    "https://i.imgur.com/OnwEDW3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorPrimary,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My pods",
                    style: Constants.boldTextStyle(Constants.colorSecondary,
                        MediaQuery.of(context).size.width * .035),
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: Constants.colorPrimary,
                        border: Border.all(color: Constants.textColorGrey),
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(15, 15))),
                    child: IconButton(
                        onPressed: () {
                          displaySuccessToastMessage(context, "Notifications");
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const LoginScreen()),
                          //     (route) => false);
                        },
                        icon: const Icon(
                          Icons.menu,
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchAnchor(
                    viewBackgroundColor: Constants.colorPrimary,
                    viewSurfaceTintColor: Constants.colorPrimary,
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                        trailing: <Widget>[
                          Tooltip(
                            message: 'Change brightness mode',
                            child: IconButton(
                              isSelected: isDark,
                              onPressed: () {
                                setState(() {
                                  isDark = !isDark;
                                });
                              },
                              icon: const Icon(Icons.wb_sunny_outlined),
                              selectedIcon:
                                  const Icon(Icons.brightness_2_outlined),
                            ),
                          )
                        ],
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    }),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: !isRoscas
                              ? Constants.bgDarkGreen
                              : Constants.textColorGrey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Constants.textColorGrey,
                                style: BorderStyle.solid),
                            top: BorderSide(
                                width: 1, color: Constants.textColorGrey),
                            right: BorderSide(
                                width: 1, color: Constants.textColorGrey),
                            left: BorderSide(
                                width: 1, color: Constants.textColorGrey),
                          )),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              isRoscas = false;
                            });
                          },
                          child: Text("Chamas",
                              style: Constants.normalTextStyle(
                                  Constants.colorPrimary, 16.0)))),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: isRoscas
                              ? Constants.bgDarkGreen
                              : Constants.textColorGrey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Constants.textColorGrey,
                                style: BorderStyle.solid),
                            top: BorderSide(
                                width: 1, color: Constants.textColorGrey),
                            right: BorderSide(
                                width: 1, color: Constants.textColorGrey),
                            left: BorderSide(
                                width: 1, color: Constants.textColorGrey),
                          )),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              isRoscas = true;
                            });
                          },
                          child: Text("Roscas",
                              style: Constants.normalTextStyle(
                                  Constants.colorPrimary, 16.0))))
                ],
              ),
              SizedBox(
                height: 500, // Set a fixed height
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    _buildPodCard(
                        true,
                        "CHAMA GROUP 4",
                        "https://i.imgur.com/CzXTtJV.jpg",
                        "120,000 Ksh",
                        images,
                        "10,000",
                        "05/08/2024"),
                    _buildPodCard(
                        true,
                        "CHAMA GROUP 4",
                        "https://i.imgur.com/CzXTtJV.jpg",
                        "120,000 Ksh",
                        images,
                        "10,000",
                        "05/08/2024"),
                    _buildPodCard(
                        true,
                        "CHAMA GROUP 4",
                        "https://i.imgur.com/CzXTtJV.jpg",
                        "120,000 Ksh",
                        images,
                        "10,000",
                        "05/08/2024"),
                    _buildPodCard(
                        true,
                        "CHAMA GROUP 4",
                        "https://i.imgur.com/CzXTtJV.jpg",
                        "120,000 Ksh",
                        images,
                        "10,000",
                        "05/08/2024"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodCard(
      bool groupStatus,
      String groupName,
      String groupPicUrl,
      String groupPotAmount,
      List<String> usersImageUrls,
      String individualUpcomingContribution,
      String contributionDueDate) {
    return Card(
      color: Constants.bgLightBrown,
      margin: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        height: MediaQuery.of(context).size.height * .4,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(groupStatus ? "active" : "false",
                      style: Constants.normalTextStyle(Constants.textColorBlack,
                          MediaQuery.of(context).size.width * .03)),
                  backgroundColor: const Color.fromARGB(221, 247, 247, 247),
                ),
                Text(
                  groupName,
                  style: Constants.boldTextStyle(Constants.textColorBlack,
                      MediaQuery.of(context).size.width * .02),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total pot amount",
                        style: Constants.normalTextStyle(
                            Constants.textColorBlack,
                            MediaQuery.of(context).size.width * .03),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          groupPotAmount,
                          style: Constants.boldTextStyle(Constants.bgDarkBrown,
                              MediaQuery.of(context).size.width * .05),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: usersImageUrls
                                .map((imageUrl) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(imageUrl),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(groupPicUrl),
                      ),
                      Image.asset(
                        "assets/images/ellipseimagedark.png",
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width * 0.14,
                      )
                    ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Upcoming payouts",
                    style: Constants.normalTextStyle(Constants.textColorBlack,
                        MediaQuery.of(context).size.width * .03)),
                Text(
                  individualUpcomingContribution,
                  style: Constants.normalTextStyle(Constants.bgDarkBrown,
                      MediaQuery.of(context).size.width * .03),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Due",
                    style: Constants.normalTextStyle(Constants.textColorBlack,
                        MediaQuery.of(context).size.width * .03)),
                Text(
                  contributionDueDate,
                  style: Constants.normalTextStyle(Constants.bgDarkBrown,
                      MediaQuery.of(context).size.width * .03),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
