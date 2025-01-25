import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/core/models/employee.dart';
import 'package:schedule_app/core/repository/fetch_data_repository.dart';

part 'all_employees_event.dart';

part 'all_employees_state.dart';

class AllEmployeesBloc extends Bloc<AllEmployeesEvent, AllEmployeesState> {
  final FetchDataRepository fetchDataRepository;

  AllEmployeesBloc(this.fetchDataRepository) : super(AllEmployeesInitial()) {
    on<FetchAllEmployeesData>((event, emit) async {
      emit(AllEmployeesLoading());
      try {
        var emps = await fetchDataRepository.fetchAllEmployeesData();
        emit(AllEmployeesLoaded(employees: emps));
      } catch (e) {
        emit(AllEmployeesError(errorMessage: e.toString()));
      }
    });
  }
}
