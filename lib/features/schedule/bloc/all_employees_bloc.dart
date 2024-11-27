import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/employee.dart';

part 'all_employees_event.dart';

part 'all_employees_state.dart';

class AllEmployeesBloc extends Bloc<AllEmployeesEvent, AllEmployeesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AllEmployeesBloc() : super(AllEmployeesInitial()) {
    on<FetchAllEmployeesData>(_onFetchAllEmployeesData);
  }

  Future<void> _onFetchAllEmployeesData(
      FetchAllEmployeesData event, Emitter<AllEmployeesState> emit) async {
    emit(AllEmployeesLoading());
    try {
      final QuerySnapshot snapshot = await _firestore.collection('users').get();

      final List<Employee> allEmployees = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Employee(
          name: data['name'],
          surname: data['surname'],
          isAdmin: data['is_admin'],
          description: data['description'],
          email: data['email'],
          number: data['number'],
          imageUrl: data['image_url'],
          employeeId: doc.id,
        );
      }).toList();

      if (allEmployees.isEmpty) {
        emit(
            AllEmployeesError(errorMessage: 'Данные пользователей не найдены'));
        return;
      }

      emit(AllEmployeesLoaded(employees: allEmployees));
    } catch (e) {
      emit(AllEmployeesError(errorMessage: e.toString()));
    }
  }
}
