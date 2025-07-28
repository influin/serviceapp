import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String organizationName;
  final DateTime lastDateToApply;
  final String applyLink;
  final String jobType;

  const JobCard({
    super.key,
    required this.jobTitle,
    required this.organizationName,
    required this.lastDateToApply,
    required this.applyLink,
    required this.jobType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(organizationName),
            const SizedBox(height: 8),
            Text('Last Date: ${lastDateToApply.toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Type: $jobType'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Apply Now')),
          ],
        ),
      ),
    );
  }
}
