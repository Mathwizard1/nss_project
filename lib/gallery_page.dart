import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String? _selectedEventDocId;

  late Future<QuerySnapshot> _eventsColSnapFuture;

  @override
  void initState() {
    super.initState();
    _eventsColSnapFuture =
        FirebaseFirestore.instance.collection('events').get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _eventsColSnapFuture,
      builder: (context, eventsColAsyncSnap) {
        if (!eventsColAsyncSnap.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final QuerySnapshot eventsColSnap = eventsColAsyncSnap.data!;

        final double screenWidth = MediaQuery.sizeOf(context).width;
        final double screenHeight = MediaQuery.sizeOf(context).height;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gallery'),
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple[300],
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.025 * screenHeight),
                child: Center(
                  child: DropdownMenu<String>(
                    hintText: 'Select an event',
                    expandedInsets:
                        EdgeInsets.symmetric(horizontal: 0.05 * screenWidth),
                    onSelected: (selectedEventDocId) => setState(() {
                      _selectedEventDocId = selectedEventDocId;
                    }),
                    dropdownMenuEntries: eventsColSnap.docs
                        .map<DropdownMenuEntry<String>>((eventDocSnap) =>
                            DropdownMenuEntry<String>(
                                value: eventDocSnap.id,
                                label: eventDocSnap['title']))
                        .toList(),
                  ),
                ),
              ),
              (_selectedEventDocId == null)
                  ? const Center(child: Text('Uploaded images show up here'))
                  : FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child(_selectedEventDocId!)
                          .listAll(),
                      builder: (context, listResAsyncSnap) {
                        if (!listResAsyncSnap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final List<Reference> eventImageRefs =
                            listResAsyncSnap.data!.items;

                        if (eventImageRefs.isEmpty) {
                          return const Center(
                              child: Text('No uploaded images yet'));
                        }

                        return Expanded(
                          child: GridView.count(
                            padding: EdgeInsets.all(0.025 * screenWidth),
                            mainAxisSpacing: 0.025 * screenWidth,
                            crossAxisSpacing: 0.025 * screenWidth,
                            crossAxisCount: 2,
                            children: eventImageRefs.map<Widget>((ref) {
                              return FutureBuilder(
                                future: ref.getDownloadURL(),
                                builder: (context, urlAsyncSnap) {
                                  if (!urlAsyncSnap.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return CachedNetworkImage(
                                    imageUrl: urlAsyncSnap.data!,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
