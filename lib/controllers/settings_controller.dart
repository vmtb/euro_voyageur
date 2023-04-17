import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivo/utils/helper_preferences.dart';


final darkProvider = StateProvider((ref)=>false);
final darkFutureProvider = FutureProvider((ref)=>SettingsController(ref).getIsDarkOrNot());

class SettingsController {
  final Ref ref;

  SettingsController(this.ref);

  Future<bool> getIsDarkOrNot() async{
    String? content = await HelperPreferences.retrieveStringValue("dark");
    if(content==null || content.isEmpty){
      //It's light
      ref.read(darkProvider.state).state = false;
      return false;
    }else{
      ref.read(darkProvider.state).state = true;
      return true;
    }
  }

  Future<bool> saveDark(bool isDark) async{
    HelperPreferences.saveStringValue("dark", isDark?"yes":"");
    //ref.refresh(darkFutureProvider);
    return true;
  }

}