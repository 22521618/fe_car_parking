import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import '../blocs/vehicles/vehicles_bloc.dart';
import '../blocs/vehicles/vehicles_event.dart';
import '../blocs/vehicles/vehicles_state.dart';
import '../models/vehicle.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehiclesBloc>().add(const LoadVehicles());
    context.read<VehiclesBloc>().add(const LoadResidents());
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
                    'Vehicles Management',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showVehicleDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Register Vehicle'),
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vehicles Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showVehicleDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Register Vehicle'),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<VehiclesBloc, VehiclesState>(
                builder: (context, state) {
                  if (state.status == VehiclesStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == VehiclesStatus.error) {
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
                        minWidth: 900, // Ensure scrolling on small screens
                        columns: const [
                          DataColumn2(
                              label: Text('License Plate'), size: ColumnSize.L),
                          DataColumn(label: Text('Card ID')),
                          DataColumn(label: Text('Owner')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Brand')),
                          DataColumn(label: Text('Color')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.vehicles.map((vehicle) {
                          return DataRow(cells: [
                            DataCell(Text(vehicle.licensePlate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text(vehicle.cardId ?? '-')),
                            DataCell(
                                Text(vehicle.resident?.fullName ?? 'Unknown')),
                            DataCell(Text(vehicle.vehicleType)),
                            DataCell(Text(vehicle.brand)),
                            DataCell(Text(vehicle.color)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: vehicle.status == 'active'
                                      ? Colors.green.withAlpha(26)
                                      : Colors.grey.withAlpha(26),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  vehicle.status,
                                  style: TextStyle(
                                    color: vehicle.status == 'active'
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
                                  onPressed: () => _showVehicleDialog(context,
                                      vehicle: vehicle),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _confirmDelete(context, vehicle),
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

  void _showVehicleDialog(BuildContext context, {Vehicle? vehicle}) {
    final isEditing = vehicle != null;
    final formKey = GlobalKey<FormState>();
    String licensePlate = vehicle?.licensePlate ?? '';
    String? cardId = vehicle?.cardId;
    String residentId = vehicle?.residentId ?? '';
    String vehicleType = vehicle?.vehicleType ?? 'car';
    String brand = vehicle?.brand ?? '';
    String color = vehicle?.color ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEditing ? 'Edit Vehicle' : 'Register Vehicle'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: licensePlate,
                  decoration: const InputDecoration(labelText: 'License Plate'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => licensePlate = v!,
                ),
                TextFormField(
                  initialValue: cardId,
                  decoration: const InputDecoration(labelText: 'Card ID'),
                  onSaved: (v) => cardId = v?.isNotEmpty == true ? v : null,
                ),
                // TextFormField(
                //   initialValue: residentId,
                //   decoration: const InputDecoration(labelText: 'Resident ID'),
                //   validator: (v) => v!.isEmpty ? 'Required' : null,
                //   onSaved: (v) => residentId = v!,
                // ),
                BlocBuilder<VehiclesBloc, VehiclesState>(
                  builder: (context, state) {
                    return DropdownButtonFormField<String>(
                      value: residentId.isNotEmpty ? residentId : null,
                      decoration: const InputDecoration(labelText: 'Resident'),
                      items: state.residents.map((resident) {
                        return DropdownMenuItem(
                          value: resident.id,
                          child: Text(
                              '${resident.fullName} (${resident.apartmentNumber})'),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() {
                        residentId = v!;
                      }),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => residentId = v!,
                    );
                  },
                ),
                DropdownButtonFormField<String>(
                  value: vehicleType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'car', child: Text('Car')),
                    DropdownMenuItem(
                        value: 'motorbike', child: Text('Motorbike')),
                  ],
                  onChanged: (v) => vehicleType = v!,
                ),
                TextFormField(
                  initialValue: brand,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => brand = v!,
                ),
                TextFormField(
                  initialValue: color,
                  decoration: const InputDecoration(labelText: 'Color'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => color = v!,
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
                final newVehicle = Vehicle(
                  id: vehicle?.id ?? '',
                  licensePlate: licensePlate,
                  cardId: cardId,
                  residentId: residentId,
                  vehicleType: vehicleType,
                  brand: brand,
                  color: color,
                  status: 'active',
                );

                if (isEditing) {
                  context.read<VehiclesBloc>().add(UpdateVehicle(newVehicle));
                } else {
                  context.read<VehiclesBloc>().add(RegisterVehicle(newVehicle));
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(isEditing ? 'Update' : 'Register'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content:
            Text('Are you sure you want to delete ${vehicle.licensePlate}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<VehiclesBloc>().add(DeleteVehicle(vehicle.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
