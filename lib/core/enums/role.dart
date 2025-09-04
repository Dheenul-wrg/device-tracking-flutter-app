enum Role {
  developer('Developer'),
  seniorDeveloper('Senior Developer'),
  leadDeveloper('Lead Developer'),
  tester('Tester'),
  seniorTester('Senior Tester'),
  leadTester('Lead Tester'),
  admin('Admin'),
  projectManager('Project Manager'),
  architect('Architect'),
  deliveryManager('Delivery Manager'),
  unknownRole('Unknown role');

  final String value;
  const Role(this.value);

  static Role fromValue(String input) {
    return Role.values.firstWhere(
      (role) => role.value.toLowerCase() == input.toLowerCase(),
      orElse: () => Role.unknownRole,
    );
  }
}
