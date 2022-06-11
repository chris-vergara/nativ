part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

@immutable
class AppState extends Equatable {
  final AppStatus status;
  final User user;

  const AppState._({
    required this.status,
    this.user = User.empty,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  @override
  // TODO: implement props
  List<Object?> get props => [status, user];
}
