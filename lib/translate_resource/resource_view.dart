import 'package:flutter/material.dart';
import 'package:languages/translate_resource/resource_model.dart';
import 'package:intl/intl.dart';

class ResourceView extends StatelessWidget {
  final ResourceModel resource;

  ResourceView({super.key, required this.resource});

  String convertTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.20),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 5, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            resource.resource_id ?? 'Unknown ID',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(resource.language_id ?? 'Unknown Language'),
                      ],
                    ),
                    Text(
                      resource.updated_at != null
                          ? convertTimestamp(resource.updated_at!)
                          : 'Unknown Date',
                      style: const TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(resource.value ?? 'No value available', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
