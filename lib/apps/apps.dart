import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/apps/convertor.dart';
import 'package:nsideas/functions.dart';
import '../home_page/home_page.dart';
import '../test.dart';
import 'creator.dart';

class Apps extends StatefulWidget {
  List<AppsConverter> appsData;

  Apps({required this.appsData});

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  bool _isBottomSheetVisible = false;
  void _showInitialBottomSheet(AppsConverter data) {
    setState(() {
      _isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isBottomSheetVisible = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 27, 32, 35),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ImageShowAndDownload(
                                    id: "app",
                                    image: data.icon.fileUrl,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.name,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Version : v${data.version}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Icon(
                                                Icons.circle,
                                                size: 5,
                                                color: Colors.white
                                            ),
                                          ),
                                          Text(
                                            " Size : ${data.size}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            data.supportsAds
                                                ? "Contains Ads"
                                                : " No Ads",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                            ),
                                          ),
                                          if (data.supportsAds)
                                            Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Icon(
                                                  Icons.circle,
                                                  size: 5,color: Colors.white
                                              ),
                                            ),
                                          if (data.supportsAds)
                                            Text(
                                              " In App Purchases",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,color: Colors.white
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  )),
                              if (isOwner())
                                PopupMenuButton<String>(
                                  child: Icon(Icons.more_vert),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppCreator(data: data)));
                                    } else if (value == 'delete') {
                                      showToastText('Delete action selected');
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Download App",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                      Text(
                                        "Updated on ${data.updateDate}",
                                        style: TextStyle(fontSize: 12,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      padding: EdgeInsets.only(left: 20),
                                      itemCount: data.appDownloadLinks.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, int index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.circle,size: 5,color: Colors.white),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                child: Text(data.appDownloadLinks[index]
                                                    .platform,style: TextStyle(fontSize: 20,color: Colors.white),),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (data.appDownloadLinks[index]
                                                    .link.isNotEmpty)
                                                  ExternalLaunchUrl(data
                                                      .appDownloadLinks[index]
                                                      .link);
                                                else
                                                  showToastText("Unavailable");
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2, horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  "Get It",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),

                                ],
                              ),
                            ),

                            if(data.appSupportedLanguages.isNotEmpty)Text(
                              "Lang - ${data.appSupportedLanguages.first}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,color: Colors.white
                              ),
                            ),
                            Text(
                              "For Devices - ${data.appSupportedDevices.join(",")}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: data.images.length,
                          itemBuilder: (context, int index) => Padding(
                            padding: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 9 / 15,
                                child: ImageShowAndDownload(
                                  image: data.images[index].fileUrl,
                                  id: "app",
                                  isZoom: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      HeadingH2(heading: "About App"),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 5),
                        child: Text(data.about,style: TextStyle(color: Colors.white),),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.only(left: 20,bottom: 5),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.points.length,
                        itemBuilder: (context, int index) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Icon(
                                Icons.circle,
                                size: 5,color: Colors.white
                            ),
                            Text(
                              " ${data.points[index]}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          "By ${data.developer.name}",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _isBottomSheetVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Our Apps",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white),
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 5),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.appsData.length,
                  itemBuilder: (context, int index) {
                    return InkWell(
                      onTap: (){
                        _showInitialBottomSheet(widget.appsData[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ImageShowAndDownload(
                                  id: "app",
                                  image: widget.appsData[index].icon.fileUrl,
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.appsData[index].name,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.appsData[index].appSupportedDevices
                                              .join(","),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Icon(
                                            Icons.circle,
                                            color: Colors.white,
                                            size: 5,
                                          ),
                                        ),
                                        Text(
                                          widget.appsData[index].supportsAds
                                              ? "Contains Ads"
                                              : "Ad Free",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                      ],
                                    ),

                                  ],
                                )),
                            InkWell(
                                onTap: () {
                                  if (widget.appsData[index].appDownloadLinks.first.link
                                      .isNotEmpty)
                                    ExternalLaunchUrl(widget
                                        .appsData[index].appDownloadLinks.first.link);
                                  else
                                    showToastText("Unavailable");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.appsData[index].appDownloadLinks.first
                                            .platform,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      Text(
                                        " - Get It",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
