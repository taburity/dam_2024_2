import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final rows = [
      {"firstName": "Leia", "lastName": "Organa"},
      {"firstName": "Luke", "lastName": "Skywalker"},
      {"firstName": "Han", "lastName": "Solo"},
    ]..sort((a, b) => a['lastName']!.compareTo(b['lastName']!));

    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(height: 50),
              DataTable(
                sortColumnIndex: 1,
                sortAscending: true,
                columns: [
                  DataColumn(
                    label: Text("First Name"),
                  ),
                  DataColumn(
                    label: Text("Last Name"),
                    tooltip: "Ordenado por último nome",
                  ),
                ],
                rows: rows
                    .map(
                      (row) => DataRow(
                    cells: [
                      DataCell(Text(row['firstName']!)),
                      DataCell(Text(row['lastName']!)),
                    ],
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
