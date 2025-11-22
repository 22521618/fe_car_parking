import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import '../blocs/residents/residents_bloc.dart';
import '../blocs/residents/residents_event.dart';
import '../blocs/residents/residents_state.dart';
import '../models/resident.dart';

class ResidentsScreen extends StatefulWidget {
  const ResidentsScreen({super.key});

  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ResidentsBloc>().add(const LoadResidents());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSmallScreen)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Residents Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showResidentDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Resident'),
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Residents Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showResidentDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Resident'),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<ResidentsBloc, ResidentsState>(
                builder: (context, state) {
                  if (state.status == ResidentsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ResidentsStatus.error) {
                    return Center(child: Text('Error: ${state.error}'));
                  }

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth:
                            600, // Force horizontal scroll on small screens
                        columns: const [
                          DataColumn2(
                              label: Text('Full Name'), size: ColumnSize.L),
                          DataColumn(label: Text('Apartment')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.residents.map((resident) {
                          return DataRow(cells: [
                            DataCell(Text(resident.fullName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500))),
                            DataCell(Text(resident.apartmentNumber)),
                            DataCell(Text(resident.phoneNumber)),
                            DataCell(Text(resident.email)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: resident.status == 'active'
                                      ? Colors.green.withAlpha(26)
                                      : Colors.grey.withAlpha(26),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  resident.status,
                                  style: TextStyle(
                                    color: resident.status == 'active'
                                        ? Colors.green
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _showResidentDialog(context,
                                      resident: resident),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _confirmDelete(context, resident),
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResidentDialog(BuildContext context, {Resident? resident}) {
    final isEditing = resident != null;
    final formKey = GlobalKey<FormState>();
    String fullName = resident?.fullName ?? '';
    String apartmentNumber = resident?.apartmentNumber ?? '';
    String phoneNumber = resident?.phoneNumber ?? '';
    String email = resident?.email ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEditing ? 'Edit Resident' : 'Add Resident'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: fullName,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => fullName = v!,
                ),
                TextFormField(
                  initialValue: apartmentNumber,
                  decoration:
                      const InputDecoration(labelText: 'Apartment Number'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => apartmentNumber = v!,
                ),
                TextFormField(
                  initialValue: phoneNumber,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => phoneNumber = v!,
                ),
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => email = v!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final newResident = Resident(
                  id: resident?.id ?? '',
                  fullName: fullName,
                  apartmentNumber: apartmentNumber,
                  phoneNumber: phoneNumber,
                  email: email,
                  status: 'active',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                if (isEditing) {
                  context
                      .read<ResidentsBloc>()
                      .add(UpdateResident(newResident));
                } else {
                  context
                      .read<ResidentsBloc>()
                      .add(CreateResident(newResident));
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Resident resident) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${resident.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<ResidentsBloc>().add(DeleteResident(resident.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
