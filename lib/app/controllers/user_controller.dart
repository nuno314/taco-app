import 'package:supabase_flutter/supabase_flutter.dart';

class UserSolidController {
  final supabase = Supabase.instance.client;

  Future<void> getProfile() async {
    // try {
    //   final userId = supabase.auth.currentSession!.user.id;
    //   final data =
    //       await supabase.from('profiles').select().eq('id', userId).single();
    //   _usernameController.text = (data['username'] ?? '') as String;
    //   _websiteController.text = (data['website'] ?? '') as String;
    //   _avatarUrl = (data['avatar_url'] ?? '') as String;
    // } on PostgrestException catch (error) {
    //   if (mounted) context.showSnackBar(error.message, isError: true);
    // } catch (error) {
    //   if (mounted) {
    //     context.showSnackBar('Unexpected error occurred', isError: true);
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _loading = false;
    //     });
    //   }
    // }
  }
}
