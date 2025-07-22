import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upworkfiverrtools/screens/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';


class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _DashboardPageState();
}

TextEditingController description = TextEditingController();
TextEditingController output = TextEditingController();
final ScrollController scroll = ScrollController();
// Selected value
String selectedValue = 'Cover Letter';

// Dropdown options
final List<String> dropdownItems = [
  'Cover Letter',
  'Cold Outreach Email',
  'Follow-up Message',
  'Custom Question',
];

class _DashboardPageState extends State<Generator> {
  int? credits;

  @override
  void initState() {
    super.initState();
    fetchCredits();
  }

  Future<void> fetchCredits() async {
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id;
    final userg = Supabase.instance.client.auth.currentUser;
    final avatarUrl = userg?.userMetadata?['avatar_url'];



    // await Supabase.instance.client
    //     .from('user_profiles')
    //     .update({'profileDescription': 'Hello, this is my new description'})
    //     .eq('id', userId)
    //     .maybeSingle();


    if (userId != null) {
      try {
        final response = await Supabase.instance.client
            .from('user_profiles')
            .select('credits')
            .eq('id', userId)
            .single();

        print("Supabase response: $response");

        setState(() {
          credits = response['credits'];
        });
      } catch (e) {
        print("Error fetching credits: $e");
      }
    }
  }

  @override

  Future<String> sendToOpenRouter(String input) async {
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer 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',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://localhost:3000', // use localhost if testing
      'X-Title': 'Prolancer', // optional
    };

    final body = jsonEncode({
      'model': 'mistralai/mistral-small-3.2-24b-instruct:free',
      'messages': [
        {'role': 'user', 'content': input}
      ],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Error: ${response.body}';
    }
  }


  Future<void> checkProfileDescription() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('user_profiles')
        .select('profileDescription')
        .eq('id', userId)
        .single();

    final description = response['profileDescription'];

    if (description == null || description.toString().trim().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Complete Your Profile'),
            content: Text('Please fill out your profile description to complete onboarding.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Got it'),
              ),
            ],
          ),
        );
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final userEmail = Supabase.instance.client.auth.currentUser?.email;
    final user = Supabase.instance.client.auth.currentUser;
    final username = user?.userMetadata?['name'];




    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: Image(
                image: AssetImage('/Users/jawadulhassan/Downloads/logo.png'),
              ),
            ),
          ),
        ),
        actions: [
          // Profile Picture
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Builder(
              builder: (context) {
                final user = Supabase.instance.client.auth.currentUser;
                final avatarUrl = user?.userMetadata?['avatar_url'];

                return CircleAvatar(
                  radius: 20,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null ? Icon(Icons.person) : null,
                );
              },
            ),
          ),

          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => DashboardPage()));
                                },
                                child: Text("Dashboard")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {}, child: Text("Generator"),style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 40,
                              spreadRadius: 0,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Job Description",
                              style: GoogleFonts.montserrat(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1,
                              )

                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Scrollbar(
                                controller: scroll,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: scroll,
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    height: 150, // Adjust height based on desired visible lines
                                    child: TextField(
                                      controller: description,
                                      expands: true,
                                      maxLines: null,
                                      minLines: null,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Job Description 💼',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Response Type", style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -1,
                                    ),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedValue,
                                    items: dropdownItems.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    decoration: InputDecoration(
                                      labelText: 'Select an Option',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30)
                                      ),
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                            ElevatedButton(onPressed: () async {
                              final userId2 = Supabase.instance.client.auth.currentUser!.id;
                              final bandakidescription = await Supabase.instance.client
                                  .from('user_profiles')
                                  .select('profileDescription')
                                  .eq('id', userId2)
                                  .maybeSingle();
                              final reply = await sendToOpenRouter(
                                  "You have to provide me with a persoanlised cover letter for the job proposal. My profile is $bandakidescription"
                              );
                              setState(() {
                                output.text = reply;
                              });// Or show in a Text widget


                            }, child: Text("Update"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 40,
                              spreadRadius: 0,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Personalised Cover Letter",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,

                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 150, // Fixed height for scrollable area
                                  child: Scrollbar(
                                    controller: scroll,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: scroll,
                                      child: TextField(
                                        controller: output,
                                        readOnly: true,
                                        maxLines: null,
                                        decoration: InputDecoration.collapsed(
                                          hintText: 'Your Response Will Be Here',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Container())
        ],
      ),
    );
  }
}