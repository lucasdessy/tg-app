import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_platform_app/application/user/edit_profile/edit_profile_cubit.dart';
import 'package:sales_platform_app/application/user/user_view_model.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:sales_platform_app/injection.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/app/util/input_formatters.dart';
import 'package:sales_platform_app/presentation/app/util/phone_formatter.dart';
import 'package:sales_platform_app/presentation/profile/widgets/profile_card.dart';
import 'package:sales_platform_app/presentation/shared/widgets/button.dart';
import 'package:sales_platform_app/presentation/shared/widgets/input_field.dart';
import 'package:sales_platform_app/presentation/shared/widgets/snackbar.dart';
import 'package:sales_platform_app/presentation/shared/widgets/source_picker.dart';
import 'package:sales_platform_app/presentation/shared/widgets/spacer.dart';
import 'package:sales_platform_app/presentation/shared/widgets/text.dart';

import '../app/util/format_date.dart';
import '../shared/config.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditProfileCubit>()..loadProfile(),
      child: const _EditProfilePage(),
    );
  }
}

class _EditProfilePage extends StatefulWidget with Printable {
  const _EditProfilePage({Key? key}) : super(key: key);

  @override
  State<_EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<_EditProfilePage> with Printable {
  // Masks
  final _phoneFormatter = AppFoneCelularMask();
  final _dateFormatter = AppMasks.dataMask.toMask;
  final _cepFormatter = AppMasks.cepMask.toMask;

  // Controllers
  final _professionController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aboutController = TextEditingController();

  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _professionController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  bool editingPersonalInfo = false;
  bool editingAddressInfo = false;

  void onSave() {
    setState(() {
      editingPersonalInfo = false;
      editingAddressInfo = false;
    });
  }

  bool canEditInfo() {
    return !editingPersonalInfo && !editingAddressInfo;
  }

  // Header
  bool isEditingHeader = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EditProfileCubit>();
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        state.mapOrNull(
          error: (value) {
            Navigator.of(context).pop();
            buildAppSnackBar(
              context,
              message: value.error,
              isFailure: true,
              icon: const Icon(Icons.error),
            );
          },
          loaded: (value) {
            if (value.needsToClear) {
              log('Setting controllers with loaded data');
              // Populate controllers
              _professionController.text =
                  value.user.personalInfo.profession ?? '';
              _birthDateController.text =
                  value.user.personalInfo.birthDate?.format ?? '';
              _phoneController.text = value.user.personalInfo.phone ?? '';
              _aboutController.text = value.user.personalInfo.aboutMe ?? '';

              _cepController.text = value.user.address.cep ?? '';
              _streetController.text = value.user.address.street ?? '';
              _numberController.text = value.user.address.number ?? '';
              _complementController.text = value.user.address.complement ?? '';
              _neighborhoodController.text =
                  value.user.address.neighborhood ?? '';
              _stateController.text = value.user.address.state ?? '';
              _cityController.text = value.user.address.city ?? '';
              cubit.onClearControllers();
            }
            if (value.success) {
              buildAppSnackBar(
                context,
                message: 'Perfil atualizado com sucesso',
                isFailure: false,
                icon: const Icon(Icons.check),
              );
              cubit.clearSuccess();
            }
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: cubit.state.maybeMap<Widget>(
          orElse: () => const SizedBox(),
          loading: (value) => const Center(
            child: CupertinoActivityIndicator(),
          ),
          loaded: (state) => SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: cubit.loadProfile,
              child: ListView(
                children: [
                  ProfileCard(
                    user: cubit.state.mapOrNull<UserViewModel>(
                      loaded: (value) => value.user,
                    ),
                    loading: cubit.state.mapOrNull<bool>(
                          loading: (value) => true,
                        ) ??
                        false,
                    isForEditPage: true,
                    onEditProfileImage: () async {
                      if (!isEditingHeader) return;
                      final source = await buildSourcePicker(context);
                      if (source == null) return;
                      cubit.pickImage(source);
                    },
                    onEditProfile: (value) {
                      setState(() {
                        isEditingHeader = !isEditingHeader;
                      });
                      if (value == null) return;
                      if (!isEditingHeader) {
                        cubit.onNameChanged(value);
                      }
                    },
                    isEditing: isEditingHeader,
                  ),
                  Padding(
                    padding: SharedConfigs.padding,
                    child: Column(
                      children: [
                        _buildCard(
                          title: "Informações de Acesso",
                          children: [
                            _buildLabel(
                                title: "E-MAIL",
                                value: state.user.personalInfo.email ?? ""),
                            AppButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.changePassword.path);
                              },
                              child: const Text("ALTERAR SENHA"),
                            ),
                          ],
                        ),
                        _buildCard(
                          title: "Informações Pessoais",
                          editing: editingPersonalInfo,
                          onToggleEdit: () {
                            if (canEditInfo()) {
                              log("Editing personal info. Freezing previous state");
                              cubit.freezeState();
                              setState(() {
                                editingPersonalInfo = !editingPersonalInfo;
                              });
                            } else if (editingPersonalInfo) {
                              log("Canceling personal info edit. Restoring previous state");
                              cubit.restoreState();
                              setState(() {
                                editingPersonalInfo = !editingPersonalInfo;
                              });
                            }
                            if (!editingPersonalInfo) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          onSave: () {
                            cubit.save();
                            onSave();
                          },
                          children: [
                            _buildLabel(
                              title: "NOME COMPLETO",
                              value: state.user.personalInfo.fullname ?? "",
                            ),
                            _buildLabel(
                              title: "CPF",
                              value: state.user.personalInfo.cpf ?? "",
                            ),
                            AppInputField(
                              label: "PROFFISÃO",
                              controller: _professionController,
                              onChanged: (value) => cubit.onPersonalInfoChanged(
                                state.user.personalInfo
                                    .copyWith(profession: value),
                              ),
                            ),
                            AppInputField(
                              label: "DATA DE NASCIMENTO",
                              controller: _birthDateController,
                              inputFormatters: [_dateFormatter],
                              inputType: TextInputType.number,
                              onChanged: (value) {
                                final date = value.parseDate;
                                if (date != null) {
                                  cubit.onPersonalInfoChanged(
                                    state.user.personalInfo
                                        .copyWith(birthDate: date),
                                  );
                                }
                              },
                            ),
                            AppInputField(
                              label: "TELEFONE",
                              controller: _phoneController,
                              inputType: TextInputType.phone,
                              inputFormatters: [_phoneFormatter],
                              onChanged: (value) => cubit.onPersonalInfoChanged(
                                state.user.personalInfo.copyWith(phone: value),
                              ),
                            ),
                            AppInputField(
                              label: "SOBRE MIM",
                              multiline: true,
                              controller: _aboutController,
                              onChanged: (value) => cubit.onPersonalInfoChanged(
                                state.user.personalInfo
                                    .copyWith(aboutMe: value),
                              ),
                            ),
                          ],
                        ),
                        _buildCard(
                          title: "Endereço",
                          editing: editingAddressInfo,
                          onToggleEdit: () {
                            if (canEditInfo()) {
                              log("Editing personal info. Freezing previous state");
                              cubit.freezeState();
                              setState(() {
                                editingAddressInfo = !editingAddressInfo;
                              });
                            } else if (editingAddressInfo) {
                              log("Canceling personal info edit. Restoring previous state");
                              cubit.restoreState();
                              setState(() {
                                editingAddressInfo = !editingAddressInfo;
                              });
                            }
                            if (!editingAddressInfo) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          onSave: () {
                            cubit.save();
                            onSave();
                          },
                          children: [
                            AppInputField(
                              label: "CEP",
                              controller: _cepController,
                              inputType: TextInputType.number,
                              inputFormatters: [_cepFormatter],
                              onChanged: (value) => cubit.onAddressChanged(
                                state.user.address.copyWith(cep: value),
                              ),
                            ),
                            AppInputField(
                              label: "RUA",
                              controller: _streetController,
                              onChanged: (value) => cubit.onAddressChanged(
                                state.user.address.copyWith(street: value),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppInputField(
                                    label: "NÚMERO",
                                    controller: _numberController,
                                    inputType: TextInputType.number,
                                    onChanged: (value) =>
                                        cubit.onAddressChanged(
                                      state.user.address
                                          .copyWith(number: value),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: AppInputField(
                                    label: "COMPLEMENTO",
                                    controller: _complementController,
                                    onChanged: (value) =>
                                        cubit.onAddressChanged(
                                      state.user.address
                                          .copyWith(complement: value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppInputField(
                              label: "BAIRRO",
                              controller: _neighborhoodController,
                              onChanged: (value) => cubit.onAddressChanged(
                                state.user.address
                                    .copyWith(neighborhood: value),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppInputField(
                                    label: "ESTADO",
                                    controller: _stateController,
                                    onChanged: (value) =>
                                        cubit.onAddressChanged(
                                      state.user.address.copyWith(state: value),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AppInputField(
                                    label: "CIDADE",
                                    controller: _cityController,
                                    onChanged: (value) =>
                                        cubit.onAddressChanged(
                                      state.user.address.copyWith(city: value),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            bold: true,
            textAlign: TextAlign.start,
          ),
          AppText(
            text: value,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required List<Widget> children,
      bool? editing,
      Function()? onToggleEdit,
      Function()? onSave}) {
    assert(
        (editing != null && onToggleEdit != null && onSave != null) ||
            (editing == null && onToggleEdit == null && onSave == null),
        "All or none");
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppText(
                text: title,
                textAlign: TextAlign.start,
                bold: true,
              ),
              const Spacer(),
              if (editing != null)
                AppButton(
                  onPressed: onToggleEdit,
                  style: AppButtonStyle.transparent,
                  child: Row(
                    children: [
                      Text(
                        editing ? "CANCELAR" : "EDITAR",
                        style: TextStyle(color: SharedConfigs.colors.neutral),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        editing ? Icons.cancel : Icons.edit,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const AppSpacer(),
          IgnorePointer(
            ignoring: !(editing ?? true),
            child: Card(
              child: Padding(
                padding: SharedConfigs.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...children,
                    if (editing != null && editing) ...[
                      const AppSpacer(),
                      AppButton(
                        onPressed: onSave,
                        child: const Text(
                          "SALVAR",
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
