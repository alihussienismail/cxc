import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/global.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({Key key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        leadingWidth: 60,
        backgroundColor: kBackgroundHomeColor,
        elevation: 0.0,
        leading: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: isEnglish ? 20 : 0, right: isEnglish ? 0 : 20),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  height: 40,
                  width: 40,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: kBackAppIconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Language'.tr(),
          style: const TextStyle(
              color: kBackAppIconColor,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 26),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      elevation: 0,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isEnglish ? kPrimaryColor : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: isEnglish ? kPrimaryColor : Colors.white,
                        leading: svgAsset('assets/svg/language_us.svg'),
                        title: Text(
                          'English',
                          style: TextStyle(
                            color: isEnglish ? Colors.white : kBackAppIconColor,
                          ),
                        ),
                        // trailing: const Icon(Icons.check),
                        onTap: () async {
                          await storage.write(
                              key: "current_language_en", value: 'en');
                          setState(() {
                            context.setLocale(const Locale('en'));

                            isEnglish = true;
                          });
                        },
                      ),
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      elevation: 0,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: !isEnglish ? kPrimaryColor : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: !isEnglish ? kPrimaryColor : Colors.white,
                        leading: svgAsset('assets/svg/language_ar.svg'),
                        title: Text(
                          'اللغة العربية',
                          style: TextStyle(
                            color:
                                !isEnglish ? Colors.white : kBackAppIconColor,
                          ),
                        ),
                        // trailing: const Icon(Icons.check),
                        onTap: () async {
                          await storage.write(
                              key: "current_language_en", value: 'ar');
                          setState(() {
                            context.setLocale(const Locale('ar'));

                            isEnglish = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
