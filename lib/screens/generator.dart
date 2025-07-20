import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upworkfiverrtools/screens/dashboard.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _DashboardPageState();
}

TextEditingController description = TextEditingController();
TextEditingController output = TextEditingController();
final ScrollController scroll = ScrollController();

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
            flex: 1,
            child: Center(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "Welcome Back! $username",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
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
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Job Description",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,

                                ),
                                textAlign: TextAlign.left,
                              ),
                              Scrollbar(
                                controller: scroll,
                                thumbVisibility: true,

                                child: SingleChildScrollView(
                                  controller: scroll,
                                  scrollDirection: Axis.vertical,
                                  child: TextField(
                                    controller: description,
                                    maxLines: null,
                                    minLines: 4,
                                    decoration: InputDecoration(
                                      labelText: 'Enter Job Description',

                                    ),


                                  ),
                                ),
                              ),
                              ElevatedButton(onPressed: () async {
                                final userId2 = Supabase.instance.client.auth.currentUser!.id;
                                await Supabase.instance.client
                                    .from('user_profiles')
                                    .update({'profileDescription': description.text})
                                    .eq('id', userId2)
                                    .maybeSingle();
                              }, child: Text("Update"))
                            ],
                          ),
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
                                Scrollbar(
                                  controller: scroll,
                                  thumbVisibility: true,

                                  child: SingleChildScrollView(
                                    controller: scroll,
                                    scrollDirection: Axis.vertical,
                                    child: TextField(
                                      controller: output,
                                      readOnly: true,
                                      maxLines: null,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Your Response Will Appear Here',

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
          Expanded(
            flex: 1,
            child: Center(child: Container()),
          )
        ],
      ),
    );
  }
}
