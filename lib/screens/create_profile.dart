import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_a/providers/profile.dart';
import 'package:test_a/screens/product_overview_screen.dart';

class CreateProfile extends StatefulWidget {
  static const routName = '/crateProfile';

  CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final Map<String, String> _authData = {
    'name': '',
    'bio': '',
    'phone': '',
  };

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    Provider.of<Profile>(context, listen: false).uploadCover(
        name: _authData['name']!,
        bio: _authData['bio']!,
        phone: _authData['phone']!);
    Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['name'] = val!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Bio",
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your bio";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['bio'] = val!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your phone";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['phone'] = val!;
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Profile>(context, listen: false)
                            .getCoverImage();
                      },
                      child: const Text("Choose an image")),
                  if (Provider.of<Profile>(context).coverImage != null)
                    ElevatedButton(onPressed: _submit, child: const Text("Ok")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
