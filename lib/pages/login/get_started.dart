import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagxiuser/functions/functions.dart';
import 'package:tagxiuser/pages/loadingPage/loading.dart';
import 'package:tagxiuser/pages/login/getstarted_phone_otp.dart';
import 'package:tagxiuser/pages/noInternet/nointernet.dart';
import 'package:tagxiuser/pages/referralcode/referral_code.dart';
import 'package:tagxiuser/styles/styles.dart';
import 'package:tagxiuser/translations/translation.dart';
import 'package:tagxiuser/widgets/widgets.dart';
import './login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class GetStarted extends StatefulWidget {
  dynamic from;
  GetStarted({this.from, Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

String name = ''; //name of user
String email = ''; // email of user
String phoneNo = '';
dynamic proImageFile1;

class _GetStartedState extends State<GetStarted> {
  bool _loading = false;
  var verifyEmailError = '';
  var _error = '';
  ImagePicker picker = ImagePicker();
  bool _pickImage = false;
  String _permission = '';

  getGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.photos.request();
    }
    return status;
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//pick image from gallery
  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        proImageFile1 = pickedFile?.path;
        _pickImage = false;
      });
    } else {
      setState(() {
        _permission = 'noPhotos';
      });
    }
  }

//pick image from camera
  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        proImageFile1 = pickedFile?.path;
        _pickImage = false;
      });
    } else {
      setState(() {
        _permission = 'noCamera';
      });
    }
  }

  //navigate
  navigate() {
    (widget.from == '1')
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Referral()),
            (route) => false)
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GetStartedPhoneOtp()));
  }

  TextEditingController emailText =
      TextEditingController(); //email textediting controller
  TextEditingController nameText =
      TextEditingController(); //name textediting controller
  TextEditingController phoneNoText =
      TextEditingController(); //phone num textediting controller

  @override
  void initState() {
    proImageFile1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        body: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: media.width * 0.08, right: media.width * 0.08),
                height: media.height * 1,
                width: media.width * 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                        height: media.height * 0.12,
                        width: media.width * 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    Icon(Icons.arrow_back, color: textColor)),
                          ],
                        )),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: media.height * 0.04,
                          ),
                          SizedBox(
                            width: media.width * 1,
                            child: Text(
                              languages['en']['text_get_started'],
                              style: GoogleFonts.montserrat(
                                  fontSize: media.width * twentyeight,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ),
                          SizedBox(
                            height: media.height * 0.012,
                          ),
                          Text(
                            languages['en']['text_fill_form'],

                            style: GoogleFonts.montserrat(
                                fontSize: media.width * sixteen,
                                color: textColor.withOpacity(0.3)),
                          ),
                          SizedBox(height: media.height * 0.04),

                          Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _pickImage = true;
                                });
                              },
                              child: proImageFile1 != null
                                  ? Container(
                                      height: media.width * 0.4,
                                      width: media.width * 0.4,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: backgroundColor,
                                          image: DecorationImage(
                                              image: FileImage(
                                                  File(proImageFile1)),
                                              fit: BoxFit.cover)),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      height: media.width * 0.4,
                                      width: media.width * 0.4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: backgroundColor,
                                      ),
                                      child: Text(
                                        languages['en']
                                            ['text_add_photo'],
                                        style: GoogleFonts.montserrat(
                                            fontSize: media.width * fourteen,
                                            color: (isDarkTheme == true)
                                                ? Colors.black
                                                : textColor),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: media.height * 0.04),
                          InputField(
                            icon: Icons.person_outline_rounded,
                            text: languages['en']['text_name'],
                            onTap: (val) {
                              setState(() {
                                name = nameText.text;
                              });
                            },
                            textController: nameText,
                          ),
                          SizedBox(
                            height: media.height * 0.012,
                          ),
                          (widget.from == '1')
                              ? InputField(
                                  icon: Icons.email_outlined,
                                  text: languages['en']
                                      ['text_email'],
                                  onTap: (val) {
                                    setState(() {
                                      email = emailText.text;
                                    });
                                  },
                                  textController: emailText,
                                  color: (verifyEmailError == '')
                                      ? null
                                      : Colors.red,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor.withOpacity(0.6)
                                                  : underline))),
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.email_outlined,
                                          size: media.width * twentyfour,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        email,
                                        style: GoogleFonts.montserrat(
                                            fontSize: media.width * sixteen,
                                            color: textColor,
                                            letterSpacing: 2),
                                      )
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: media.height * 0.012,
                          ),
                          (widget.from == '1')
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor.withOpacity(0.6)
                                                  : underline))),
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              countries[phcode]['dial_code'],
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      media.width * sixteen,
                                                  color: textColor),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Icon(Icons.keyboard_arrow_down,
                                                color: textColor)
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        phnumber,
                                        style: GoogleFonts.montserrat(
                                            fontSize: media.width * sixteen,
                                            color: textColor,
                                            letterSpacing: 2),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  height: 55,
                                  width: media.width * 1 -
                                      (media.width * 0.08 * 2),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor.withOpacity(0.6)
                                                  : underline))),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (countries.isNotEmpty) {
                                            //dialod box for select country for dial code
                                            await showDialog(
                                                context: context,
                                                barrierColor: (isDarkTheme ==
                                                        true)
                                                    ? textColor.withOpacity(0.3)
                                                    : Colors.black
                                                        .withOpacity(0.5),
                                                builder: (context) {
                                                  var searchVal = '';
                                                  return AlertDialog(
                                                    backgroundColor: page,
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    content: StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return Container(
                                                        width:
                                                            media.width * 0.9,
                                                        decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                                                          ),
                                                        ),
                                                        child: Directionality(
                                                          textDirection:
                                                              (languageDirection ==
                                                                      'rtl')
                                                                  ? TextDirection
                                                                      .rtl
                                                                  : TextDirection
                                                                      .ltr,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                height: 40,
                                                                width: media
                                                                        .width *
                                                                    0.9,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1.5)),
                                                                child:
                                                                    TextField(
                                                                  decoration: InputDecoration(
                                                                      contentPadding: (languageDirection ==
                                                                              'rtl')
                                                                          ? EdgeInsets.only(
                                                                              bottom: media.width *
                                                                                  0.035)
                                                                          : EdgeInsets.only(
                                                                              bottom: media.width *
                                                                                  0.04),
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          languages['en']
                                                                              [
                                                                              'text_search'],
                                                                      hintStyle: GoogleFonts.montserrat(
                                                                          color:
                                                                              textColor.withOpacity(0.4),
                                                                          fontSize: media.width * sixteen)),
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                          color:
                                                                              textColor),
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      searchVal =
                                                                          val;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              Expanded(
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    children: countries
                                                                        .asMap()
                                                                        .map((i, value) {
                                                                          return MapEntry(
                                                                              i,
                                                                              SizedBox(
                                                                                width: media.width * 0.9,
                                                                                child: (searchVal == '' && countries[i]['flag'] != null)
                                                                                    ? InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            phcode = i;
                                                                                          });
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                          decoration: const BoxDecoration(
                                                                                            gradient: LinearGradient(
                                                                                              begin: Alignment.topCenter,
                                                                                              end: Alignment.bottomCenter,
                                                                                              colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                                                                                            ),
                                                                                          ),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  Image.network(countries[i]['flag']),
                                                                                                  SizedBox(
                                                                                                    width: media.width * 0.02,
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: media.width * 0.4,
                                                                                                      child: Text(
                                                                                                        countries[i]['name'],
                                                                                                        style: GoogleFonts.montserrat(fontSize: media.width * sixteen, color: textColor),
                                                                                                      )),
                                                                                                ],
                                                                                              ),
                                                                                              Text(
                                                                                                countries[i]['dial_code'],
                                                                                                style: GoogleFonts.montserrat(fontSize: media.width * sixteen, color: textColor),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ))
                                                                                    : (countries[i]['flag'] != null && countries[i]['name'].toLowerCase().contains(searchVal.toLowerCase()))
                                                                                        ? InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                phcode = i;
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                              decoration: const BoxDecoration(
                                                                                                gradient: LinearGradient(
                                                                                                  begin: Alignment.topCenter,
                                                                                                  end: Alignment.bottomCenter,
                                                                                                  colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                                                                                                ),
                                                                                              ),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      Image.network(countries[i]['flag']),
                                                                                                      SizedBox(
                                                                                                        width: media.width * 0.02,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                          width: media.width * 0.4,
                                                                                                          child: Text(
                                                                                                            countries[i]['name'],
                                                                                                            style: GoogleFonts.montserrat(fontSize: media.width * sixteen, color: textColor),
                                                                                                          )),
                                                                                                    ],
                                                                                                  ),
                                                                                                  Text(
                                                                                                    countries[i]['dial_code'],
                                                                                                    style: GoogleFonts.montserrat(fontSize: media.width * sixteen, color: textColor),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ))
                                                                                        : Container(),
                                                                              ));
                                                                        })
                                                                        .values
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  );
                                                });
                                          } else {
                                            getCountryCode();
                                          }
                                          setState(() {});
                                        },

                                        //input field
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                  countries[phcode]['flag']),
                                              SizedBox(
                                                width: media.width * 0.02,
                                              ),
                                              Text(
                                                countries[phcode]['dial_code']
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize:
                                                        media.width * sixteen,
                                                    color: textColor),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Icon(Icons.keyboard_arrow_down,
                                                  color: textColor)
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 1,
                                        height: media.width * 0.0693,
                                        color: buttonColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: media.width * 0.5,
                                        child: TextFormField(
                                          controller: phoneNoText,
                                          onChanged: (val) {
                                            setState(() {
                                              phnumber = phoneNoText.text;
                                            });
                                            if (phoneNoText.text.length ==
                                                countries[phcode]
                                                    ['dial_max_length']) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            }
                                          },
                                          maxLength: countries[phcode]
                                              ['dial_max_length'],
                                          style: GoogleFonts.montserrat(
                                              fontSize: media.width * sixteen,
                                              color: textColor,
                                              letterSpacing: 1),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: languages['en']
                                                ['text_phone_number'],
                                            counterText: '',
                                            hintStyle: GoogleFonts.montserrat(
                                                fontSize: media.width * sixteen,
                                                color:
                                                    textColor.withOpacity(0.7)),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          //email already exist error
                          (_error != '')
                              ? Container(
                                  width: media.width * 0.8,
                                  margin:
                                      EdgeInsets.only(top: media.height * 0.03),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _error,
                                    style: GoogleFonts.montserrat(
                                        fontSize: media.width * sixteen,
                                        color: Colors.red),
                                  ),
                                )
                              : Container(),

                          SizedBox(
                            height: media.height * 0.065,
                          ),
                          (widget.from == '1')
                              ? (nameText.text.isNotEmpty &&
                                      emailText.text.isNotEmpty)
                                  ? Container(
                                      width: media.width * 1,
                                      alignment: Alignment.center,
                                      child: Button(
                                          onTap: () async {
                                            String pattern =
                                                r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])*$";
                                            RegExp regex = RegExp(pattern);
                                            if (regex
                                                .hasMatch(emailText.text)) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              setState(() {
                                                verifyEmailError = '';
                                                _error = '';
                                                _loading = true;
                                              });
                                              //validate email already exist
                                              var result =
                                                  await validateEmail();

                                              if (result == 'success') {
                                                setState(() {
                                                  verifyEmailError = '';
                                                  _error = '';
                                                });
                                                var register =
                                                    await registerUser();
                                                if (register == 'true') {
                                                  //referral page
                                                  navigate();
                                                } else {
                                                  setState(() {
                                                    _error =
                                                        register.toString();
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  verifyEmailError =
                                                      result.toString();
                                                  _error = result.toString();
                                                });
                                              }
                                              setState(() {
                                                _loading = false;
                                              });
                                            } else {
                                              setState(() {
                                                verifyEmailError = languages[
                                                        'en']
                                                    ['text_email_validation'];
                                                _error = languages[
                                                        'en']
                                                    ['text_email_validation'];
                                              });
                                            }
                                          },
                                          text: languages['en']
                                              ['text_next']))
                                  : Container()
                              : (nameText.text.isNotEmpty &&
                                      phoneNoText.text.length >=
                                          countries[phcode]['dial_min_length'])
                                  ? Container(
                                      width:
                                          media.width * 1 - media.width * 0.08,
                                      alignment: Alignment.center,
                                      child: Button(
                                        onTap: () async {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          setState(() {
                                            _loading = true;
                                          });
                                          var val = await otpCall();
                                          if (val.value == true) {
                                            phoneAuthCheck = true;
                                            await phoneAuth(countries[phcode]
                                                    ['dial_code'] +
                                                phnumber);
                                            value = 0;
                                            navigate();
                                          } else {
                                            phoneAuthCheck = false;
                                            navigate();
                                          }
                                          setState(() {
                                            _loading = false;
                                          });
                                        },
                                        text: languages['en']
                                            ['text_next'],
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                    )),
                  ],
                ),
              ),

              (_pickImage == true)
                  ? Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _pickImage = false;
                          });
                        },
                        child: Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          color: Colors.transparent.withOpacity(0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: media.width * 0.02,
                                      width: media.width * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.01),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                pickImageFromCamera();
                                              },
                                              child: Container(
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: media.width * 0.064,
                                                    color: textColor,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.01,
                                            ),
                                            Text(
                                              languages['en']
                                                  ['text_camera'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * ten,
                                                  color:
                                                      const Color(0xff666666)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                pickImageFromGallery();
                                              },
                                              child: Container(
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                      Icons.image_outlined,
                                                      size: media.width * 0.064,
                                                      color: textColor)),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.01,
                                            ),
                                            Text(
                                              languages['en']
                                                  ['text_gallery'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * ten,
                                                  color:
                                                      const Color(0xff666666)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : Container(),

              //permission denied popup
              (_permission != '')
                  ? Positioned(
                      child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: media.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _permission = '';
                                      _pickImage = false;
                                    });
                                  },
                                  child: Container(
                                    height: media.width * 0.1,
                                    width: media.width * 0.1,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: page),
                                    child: const Icon(Icons.cancel_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                    width: media.width * 0.8,
                                    child: Text(
                                      (_permission == 'noPhotos')
                                          ? languages['en']
                                              ['text_open_photos_setting']
                                          : languages['en']
                                              ['text_open_camera_setting'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: textColor,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(height: media.width * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          await openAppSettings();
                                        },
                                        child: Text(
                                          languages['en']
                                              ['text_open_settings'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen,
                                              color: buttonColor,
                                              fontWeight: FontWeight.w600),
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          (_permission == 'noCamera')
                                              ? pickImageFromCamera()
                                              : pickImageFromGallery();
                                          setState(() {
                                            _permission = '';
                                          });
                                        },
                                        child: Text(
                                          languages['en']
                                              ['text_done'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen,
                                              color: buttonColor,
                                              fontWeight: FontWeight.w600),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),

              //internet not connected
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          setState(() {
                            internetTrue();
                          });
                        },
                      ))
                  : Container(),

              //loader
              (_loading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
