import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorcreattext/editortext_page.dart';
import 'package:khateeb/editorwebapp/editorpages/editorfeedback/editorfeedback_page.dart';
import 'package:khateeb/editorwebapp/editorpages/editorhome/editorhome.dart';
import 'package:khateeb/editorwebapp/editorpages/editorjoboffers/editorjoboffers_page.dart';
import 'package:khateeb/editorwebapp/editorpages/editorlogin/editor_login_page.dart';
import 'package:khateeb/editorwebapp/editorpages/editorrigester/editor_rigester_page.dart';
import 'package:khateeb/editorwebapp/editorpages/editorsearch/editorsrearch_page.dart';
import 'package:khateeb/getx_bindings/editor_home_bindings.dart';
import 'package:khateeb/getx_bindings/editor_login_bindings.dart';
import 'package:khateeb/getx_bindings/editor_rigester_bindings.dart';
import 'package:khateeb/getx_bindings/editor_search_bindings.dart';
import 'package:khateeb/getx_bindings/editor_text_bindings.dart';
import 'package:khateeb/getx_bindings/home_binding.dart';
import 'package:khateeb/getx_bindings/level_binding.dart';
import 'package:khateeb/getx_bindings/mvp_bindings.dart';
import 'package:khateeb/getx_bindings/search_binding.dart';
import 'package:khateeb/getx_bindings/text_binding.dart';
import 'package:khateeb/getx_bindings/url_binding.dart';
import 'package:khateeb/pages/URL/url_page.dart';
import 'package:khateeb/pages/level/level_page.dart';
import 'package:khateeb/pages/login/login_page.dart';
import 'package:khateeb/pages/mvp/mvp_page.dart';
import 'package:khateeb/pages/profile/profile_page.dart';
import 'package:khateeb/pages/register/register_page.dart';
import 'package:birth_picker/birth_picker.dart';
import 'package:khateeb/pages/search/search_page.dart';
import 'package:khateeb/pages/text/text_page.dart';
import 'package:khateeb/translations/translate.dart';
import 'custom.dart';
import 'editorwebapp/editorpages/editorsendassignment/editorsendassignnment_pages.dart';
import 'getx_bindings/login_binding.dart';
import 'getx_bindings/profile_binding.dart';
import 'getx_bindings/register_binding.dart';
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(
      GetMaterialApp( //same as materialapp but for get package ia easier
        initialRoute: '/login', //the page that the prog will start from
        getPages: [
          GetPage(name: '/login' ,page: ()=> LoginPage() , binding: LoginPageBinding() ),
          GetPage(name: '/register' ,page: ()=> RegisterPage() , binding: RegisterPageBinging() ),
          GetPage(name: '/home' ,page: ()=> HomePage() , binding: HomePageBinding() ),
          GetPage(name: '/profile' ,page: ()=> ProfilePage() , binding: ProfilePageBinding() ),
          GetPage(name: '/text' ,page: ()=> TextPage() , binding: TextPageBinging() ),
          GetPage(name: '/level' ,page: ()=> LevelPage() , binding: LevelPageBinding()),
          GetPage(name: '/search' ,page: ()=> SearchPage() , binding: SearchPageBinding()),
          GetPage(name: '/mvp' ,page: ()=> MvpPage() , binding: MvpPageBinding() ),
          GetPage(name: '/url' ,page: ()=> URLPage() , binding: UrlPageBinging() ),
          //editor pages
          GetPage(name: '/editorlogin' ,page: ()=> EditorLoginPage() , binding: EditorLoginPageBinding() ),
          GetPage(name: '/editorregister' ,page: ()=> EditorRegisterPage() , binding: EditorRigesterPageBinding() ),
          GetPage(name: '/editorhome' ,page: ()=> EditorHomePage() , binding: EditorHomePageBinding() ),
          GetPage(name: '/editortext' ,page: ()=> EditorTextPage() , binding: EditorTextPageBinding() ),
          GetPage(name: '/editorsearch' ,page: ()=> EditorSearchPage() , binding: EditorSearchPageBinding() ),
          GetPage(name: "/editortexts", page: () => TextsPage()),
          //shared
          GetPage(name: "/jobrequest", page: () => JobRequestsPage()),
          GetPage(name: "/feedback", page: () => FeedbackPage()),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: fourthBackColor),
          useMaterial3: true,
        ),
        translations: Translation(),
        locale: Locale('ar'),
        fallbackLocale: Locale('ar'),
        debugShowCheckedModeBanner: false,
      )
  );
}