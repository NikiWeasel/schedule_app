class Employee {
  const Employee({
    required this.employeeId,
    required this.name,
    required this.surname,
    required this.isAdmin,
    required this.description,
    required this.email,
    required this.number,
    required this.imageUrl,
  });

  final String employeeId;
  final String name;
  final String surname;
  final bool isAdmin;
  final String description;
  final String email;
  final String number;
  final String imageUrl;
}
