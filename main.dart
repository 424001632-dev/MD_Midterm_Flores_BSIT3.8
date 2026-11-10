import 'dart:io';

mixin TimestampMixin {
  final DateTime createdAt = DateTime.now();

  String getTimestamp() {
    return createdAt.toString();
  }
}

abstract class CenterRecord {
  final String id;

  CenterRecord(this.id);

  String getDetails();
}

class LearningResource extends CenterRecord with TimestampMixin {
  String _title;
  String _category;
  int _quantity;

  LearningResource(String id, this._title, this._category, this._quantity)
    : super(id);

  String get title => _title;
  String get category => _category;
  int get quantity => _quantity;

  set title(String value) {
    if (value.trim().isNotEmpty) {
      _title = value;
    }
  }

  void updateQuantity(int value) {
    if (value >= 0) {
      _quantity = value;
    }
  }

  @override
  String getDetails() {
    return 'Resource: $_title | Category: $_category | '
        'Quantity: $_quantity | Created: ${getTimestamp()}';
  }
}

class Participant extends CenterRecord with TimestampMixin {
  String _name;
  int _age;

  Participant(String id, this._name, this._age) : super(id);

  String get name => _name;
  int get age => _age;

  set name(String value) {
    if (value.trim().isNotEmpty) {
      _name = value;
    }
  }

  @override
  String getDetails() {
    return 'Participant: $_name | Age: $_age | '
        'Created: ${getTimestamp()}';
  }
}

List<CenterRecord> records = [];
Map<String, CenterRecord> recordMap = {};

String readRequiredText(String prompt) {
  while (true) {
    stdout.write(prompt);
    String value = stdin.readLineSync() ?? '';

    if (value.trim().isNotEmpty) {
      return value.trim();
    }

    print('Input cannot be empty. Try again.');
  }
}

int readPositiveInt(String prompt) {
  while (true) {
    stdout.write(prompt);

    try {
      int value = int.parse(stdin.readLineSync() ?? '');

      if (value > 0) {
        return value;
      }

      print('Please enter a number greater than zero.');
    } catch (e) {
      print('Invalid input. Please enter a valid number.');
    }
  }
}

void addResource() {
  int count = records.whereType<LearningResource>().length + 1;
  String id = 'R${count.toString().padLeft(3, '0')}';

  String title = readRequiredText('Enter resource title: ');
  String category = readRequiredText('Enter category: ');
  int quantity = readPositiveInt('Enter quantity: ');

  LearningResource resource = LearningResource(id, title, category, quantity);

  records.add(resource);
  recordMap[id] = resource;

  print('Resource successfully added! ID: $id');
}

void registerParticipant() {
  int count = records.whereType<Participant>().length + 1;
  String id = 'P${count.toString().padLeft(3, '0')}';

  String name = readRequiredText('Enter participant name: ');
  int age = readPositiveInt('Enter participant age: ');

  Participant participant = Participant(id, name, age);

  records.add(participant);
  recordMap[id] = participant;

  print('Participant successfully registered! ID: $id');
}

void viewRecords() {
  if (records.isEmpty) {
    print('No records available.');
    return;
  }

  print('\n========== ALL RECORDS ==========');

  for (CenterRecord record in records) {
    print(record.getDetails());
  }
}

void searchRecord(String id) {
  CenterRecord? record = recordMap[id];

  if (record == null) {
    print('Record not found.');
  } else {
    print(record.getDetails());
  }
}

int countRecords() {
  return records.length;
}

void displaySummary() {
  int totalResources = records.whereType<LearningResource>().length;
  int totalParticipants = records.whereType<Participant>().length;
  int totalRecords = countRecords();

  print('\n========== CENTER SUMMARY ==========');
  print('Total resources: $totalResources');
  print('Total participants: $totalParticipants');
  print('Total records: $totalRecords');
}

void main() {
  bool running = true;

  while (running) {
    print('\n====================================');
    print(' COMMUNITY LEARNING CENTER SYSTEM');
    print('====================================');
    print('1. Add Learning Resource');
    print('2. Register Participant');
    print('3. View All Records');
    print('4. Search Record');
    print('5. View Center Summary');
    print('6. Exit');

    stdout.write('\nEnter your choice: ');
    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        addResource();
        break;

      case '2':
        registerParticipant();
        break;

      case '3':
        viewRecords();
        break;

      case '4':
        String id = readRequiredText('Enter record ID: ');
        searchRecord(id);
        break;

      case '5':
        displaySummary();
        break;

      case '6':
        running = false;
        print('Thank you for using the system!');
        break;

      default:
        print('Invalid choice. Please select 1 to 6.');
    }
  }
}
