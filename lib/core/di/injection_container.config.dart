// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_faysal_game/data/repositories/auth_repository.dart'
    as _i914;
import 'package:flutter_faysal_game/presentation/providers/auth_provider.dart'
    as _i556;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i914.AuthRepository>(() => _i914.AuthRepository());
    gh.lazySingleton<_i556.AuthProvider>(
      () => _i556.AuthProvider(gh<_i914.AuthRepository>()),
    );
    return this;
  }
}
