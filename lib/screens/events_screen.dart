// ... importações
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CreateEventScreen extends StatefulWidget {
  final bool isAdmin;

  const CreateEventScreen({super.key, required this.isAdmin});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _eventTitle = '';
  String _eventDescription = '';
  DateTime? _eventDate;
  TimeOfDay? _eventTime;

  List<Map<String, dynamic>> _events = [];

  void _showEventFormModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Título do Evento',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Insira o título.'
                          : null,
                      onSaved: (value) => _eventTitle = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Descrição do Evento',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Insira a descrição.'
                          : null,
                      onSaved: (value) => _eventDescription = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            _eventDate = picked;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Data do Evento',
                            border: const OutlineInputBorder(),
                            hintText: _eventDate != null
                                ? DateFormat('dd/MM/yyyy').format(_eventDate!)
                                : 'Selecionar data',
                          ),
                          validator: (_) =>
                              _eventDate == null ? 'Selecione a data.' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _eventTime = picked;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Hora do Evento',
                            border: const OutlineInputBorder(),
                            hintText: _eventTime != null
                                ? _eventTime!.format(context)
                                : 'Selecionar hora',
                          ),
                          validator: (_) =>
                              _eventTime == null ? 'Selecione a hora.' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if ((_formKey.currentState?.validate() ?? false)) {
                          _formKey.currentState?.save();

                          // Combina data e hora em um DateTime
                          final eventDateTime = DateTime(
                            _eventDate!.year,
                            _eventDate!.month,
                            _eventDate!.day,
                            _eventTime!.hour,
                            _eventTime!.minute,
                          );

                          setState(() {
                            _events.add({
                              'title': _eventTitle,
                              'description': _eventDescription,
                              'datetime': eventDateTime,
                            });
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Salvar Evento'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programação Semanal"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bem-vindo à Programação da Semana!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Aqui você pode ver os eventos para a programação semanal.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            if (widget.isAdmin)
              Center(
                child: ElevatedButton(
                  onPressed: _showEventFormModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Adicionar Evento'),
                ),
              ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  final DateTime datetime = event['datetime'];
                  final String formattedDateTime =
                      '${DateFormat.EEEE('pt_BR').format(datetime).toLowerCase()}, '
                      '${DateFormat('dd/MM/yyyy').format(datetime)} às '
                      '${DateFormat('HH:mm').format(datetime)}';

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3557),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            event['description'],
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                formattedDateTime,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
