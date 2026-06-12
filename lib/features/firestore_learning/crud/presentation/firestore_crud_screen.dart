import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/models/user_profile.dart';
import 'package:firebase_scratchpad/features/firestore_learning/crud/application/firestore_provider.dart';

class FirestoreCrudScreen extends ConsumerStatefulWidget {
  const FirestoreCrudScreen({super.key});

  @override
  ConsumerState<FirestoreCrudScreen> createState() =>
      _FirestoreCrudScreenState();
}

class _FirestoreCrudScreenState extends ConsumerState<FirestoreCrudScreen> {
  // Input Fields Controllers
  final uidController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  UserProfileModel? loadedUser; // Declare Object

  @override
  void dispose() {
    uidController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(firestoreRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Firestore CRUD')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ID
            TextField(
              controller: uidController,
              decoration: const InputDecoration(labelText: 'UID'),
            ),

            const SizedBox(height: 12),
            // Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 12),
            //Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 20),
            // Create
            ElevatedButton(
              onPressed: () async {
                final user = UserProfileModel(
                  id: uidController.text.trim(),
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                );

                await repository.createUser(user);

                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('User Created')));
              },
              child: const Text('Create User'),
            ),

            const SizedBox(height: 10),
            // READ
            ElevatedButton(
              onPressed: () async {
                final user = await repository.getUser(
                  uidController.text.trim(),
                );

                setState(() {
                  loadedUser = user;
                });
              },
              child: const Text('Read User'),
            ),

            const SizedBox(height: 10),
            // Update
            ElevatedButton(
              onPressed: () async {
                await repository.updateUserName(
                  uid: uidController.text.trim(),
                  name: nameController.text.trim(),
                );

                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('User Updated')));
              },
              child: const Text('Update Name'),
            ),

            const SizedBox(height: 10),
            // Delete
            ElevatedButton(
              onPressed: () async {
                await repository.deleteUser(uidController.text.trim());

                setState(() {
                  loadedUser = null;
                });

                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('User Deleted')));
              },
              child: const Text('Delete User'),
            ),

            const SizedBox(height: 30),

            if (loadedUser != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('ID: ${loadedUser!.id}'),

                      Text('Name: ${loadedUser!.name}'),

                      Text('Email: ${loadedUser!.email}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
