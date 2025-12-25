import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/birth_details_model.dart';
import '../../providers/chat_provider.dart';
import '../../core/utils/validators.dart';
import '../chat/chat_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedConcern;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _concerns = [
    'Career',
    'Marriage',
    'Love',
    'Health',
    'Finance',
    'General'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Details Form'),
        backgroundColor: const Color(0xFFFFB300),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) =>
                      Validators.validateRequired(value, 'Full Name'),
                ),
                const SizedBox(height: 16),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc_outlined),
                  ),
                  items: _genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select gender' : null,
                ),
                const SizedBox(height: 16),

                // Date of Birth
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : 'Select date',
                      style: TextStyle(
                        color: _selectedDate != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Time of Birth
                InkWell(
                  onTap: _pickTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Time of Birth',
                      prefixIcon: Icon(Icons.access_time_outlined),
                    ),
                    child: Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Select time',
                      style: TextStyle(
                        color: _selectedTime != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Place of Birth
                TextFormField(
                  controller: _placeController,
                  decoration: const InputDecoration(
                    labelText: 'Place of Birth',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: 'City, State, Country',
                  ),
                  validator: (value) =>
                      Validators.validateRequired(value, 'Place of Birth'),
                ),
                const SizedBox(height: 16),

                // Current Concern
                DropdownButtonFormField<String>(
                  value: _selectedConcern,
                  decoration: const InputDecoration(
                    labelText: 'Current Concern',
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                  items: _concerns.map((concern) {
                    return DropdownMenuItem(
                      value: concern,
                      child: Text(concern),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedConcern = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a concern' : null,
                ),
                const SizedBox(height: 32),

                // Start Chat Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _startChat,
                    child: const Text('Start Astrology Chat'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _startChat() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select time of birth')),
      );
      return;
    }

    final birthDetails = BirthDetailsModel(
      fullName: _nameController.text,
      gender: _selectedGender!,
      dateOfBirth: _selectedDate!,
      timeOfBirth: _selectedTime!.format(context),
      placeOfBirth: _placeController.text,
      currentConcern: _selectedConcern!,
    );

    Provider.of<ChatProvider>(context, listen: false)
        .setBirthDetails(birthDetails);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  ChatScreen()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}
