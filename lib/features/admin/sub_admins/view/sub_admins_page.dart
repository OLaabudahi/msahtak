import 'package:Msahtak/core/services/firestore_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../_shared/admin_ui.dart';
import '../../../../core/i18n/app_i18n.dart';

import '../bloc/sub_admins_bloc.dart';
import '../bloc/sub_admins_event.dart';
import '../bloc/sub_admins_state.dart';
import '../data/repos/sub_admins_repo_impl.dart';
import '../data/sources/sub_admins_firebase_source.dart';
import '../domain/usecases/get_admin_spaces_usecase.dart';

class SubAdminsPage extends StatefulWidget {
  const SubAdminsPage({super.key});

  static Widget withBloc() {
    final source = SubAdminsFirebaseSource();
    final repo = SubAdminsRepoImpl(source);
    final usecase = GetAdminSpacesUseCase(repo);

    return BlocProvider(
      create: (_) => SubAdminsBloc(usecase)..add(LoadSubAdminsEvent()),
      child: const SubAdminsPage(),
    );
  }

  @override
  State<SubAdminsPage> createState() => _SubAdminsPageState();
}

class _SubAdminsPageState extends State<SubAdminsPage> {
  final _api =FirestoreApi();

  /// =========================
  /// CREATE
  /// =========================
  Future<void> _showCreateDialog() async {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    final selectedIds = <String>{};

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          String? error;

          Future<void> create() async {
            final name = nameCtrl.text.trim();
            final email = emailCtrl.text.trim();
            final pass = passCtrl.text.trim();

            if (name.isEmpty || email.isEmpty || pass.isEmpty) {
              setSt(() => error = 'Fill all fields');
              return;
            }

            try {
              final app = await Firebase.initializeApp(
                name: DateTime.now().millisecondsSinceEpoch.toString(),
                options: Firebase.app().options,
              );

              final cred = await FirebaseAuth.instanceFor(app: app)
                  .createUserWithEmailAndPassword(
                email: email,
                password: pass,
              );

              final uid = cred.user!.uid;

              await _api.updateFields(collection: 'users', docId: uid, data: {
                'uid': uid,
                'email': email,
                'fullName': name,
                'role': 'sub_admin',
                'assignedSpaceIds': selectedIds.toList(),
              });

              await app.delete();

              Navigator.pop(ctx);
              context.read<SubAdminsBloc>().add(LoadSubAdminsEvent());
            } catch (e) {
              setSt(() => error = e.toString());
            }
          }

          final spaces = context.read<SubAdminsBloc>().state.spaces;

          return AlertDialog(
            backgroundColor: AdminColors.bg,
            title: const Text('Create Sub Admin'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                  TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password')),

                  const SizedBox(height: 12),

                  ...spaces.map((s) {
                    final id = s['id'];
                    final name = s['spaceName'] ?? s['name'];
                    final selected = selectedIds.contains(id);

                    return CheckboxListTile(
                      value: selected,
                      title: Text(name),
                      onChanged: (_) {
                        setSt(() {
                          selected
                              ? selectedIds.remove(id)
                              : selectedIds.add(id);
                        });
                      },
                    );
                  }),

                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(onPressed: create, child: const Text('Create')),
            ],
          );
        });
      },
    );
  }

  /// =========================
  /// BUILD
  /// =========================
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubAdminsBloc, SubAdminsState>(
      builder: (context, state) {

        final spaces = state.spaces;
        final users = state.subAdmins;

        final spaceOptions = spaces.map((d) {
          final name = d['spaceName'] ?? d['name'] ?? d['id'];
          return _SpaceOption(id: d['id'], name: name);
        }).toList();

        final items = users.map((d) {
          final rawIds = d['assignedSpaceIds'];

          final assignedIds = rawIds is List
              ? rawIds.map((e) => e.toString()).toList()
              : <String>[];

          final assignedNames = assignedIds.map((id) {
            return spaceOptions.firstWhere(
                  (s) => s.id == id,
              orElse: () => _SpaceOption(id: id, name: id),
            ).name;
          }).toList();

          return _SubAdminItem(
            uid: d['id'],
            name: d['fullName'] ?? d['full_name'] ?? 'Unknown',
            email: d['email'] ?? '',
            assignedSpaceIds: assignedIds,
            assignedSpaceNames: assignedNames,
          );
        }).toList();

        return Scaffold(
          backgroundColor: AdminColors.bg,
          floatingActionButton: FloatingActionButton(
            heroTag: 'sub_admins_fab',
            backgroundColor: AdminColors.primaryAmber,
            onPressed: _showCreateDialog,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: context.t('subAdminsTitle'),
                        subtitle: context.t('subAdminsSubtitle'),
                      ),

                      if (state.loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Text(context.t('subAdminsNoItems')),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, i) => _SubAdminCard(
                              item: items[i],
                              onEdit: () => _showEditDialog(items[i]),
                              onRemove: () => _removeSubAdmin(items[i]),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// =========================
  /// EDIT
  /// =========================
  Future<void> _showEditDialog(_SubAdminItem item) async {
    final selectedIds = item.assignedSpaceIds.toSet();
    final spaces = context.read<SubAdminsBloc>().state.spaces;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSt) {

          Future<void> save() async {
            await _api.updateFields(collection:'users', docId:item.uid, data: {
              'assignedSpaceIds': selectedIds.toList(),
            });

            Navigator.pop(ctx);
            context.read<SubAdminsBloc>().add(LoadSubAdminsEvent());
          }

          return AlertDialog(
            backgroundColor: AdminColors.bg,
            title: const Text('Edit Sub Admin'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...spaces.map((s) {
                  final id = s['id'];
                  final name = s['spaceName'] ?? s['name'];
                  final selected = selectedIds.contains(id);

                  return CheckboxListTile(
                    value: selected,
                    title: Text(name),
                    onChanged: (_) {
                      setSt(() {
                        selected
                            ? selectedIds.remove(id)
                            : selectedIds.add(id);
                      });
                    },
                  );
                }),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(onPressed: save, child: const Text('Save')),
            ],
          );
        });
      },
    );
  }

  /// =========================
  /// DELETE
  /// =========================
  Future<void> _removeSubAdmin(_SubAdminItem item) async {
    await _api.updateFields(collection:'users', docId: item.uid, data: {
      'role': 'user',
      'assignedSpaceIds': [],
    });

    context.read<SubAdminsBloc>().add(LoadSubAdminsEvent());
  }
}

class _SubAdminCard extends StatelessWidget {
  final _SubAdminItem item;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _SubAdminCard({
    required this.item,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AdminColors.primaryBlue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              item.name.isNotEmpty
                  ? item.name[0].toUpperCase()
                  : '?',
              style: AdminText.body16(
                color: AdminColors.primaryBlue,
                w: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// 🔹 البيانات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AdminText.body16(w: FontWeight.w700),
                ),
                Text(
                  item.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AdminText.body14(),
                ),

                if (item.assignedSpaceNames.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: item.assignedSpaceNames.map((name) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AdminColors.primaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          name,
                          style: AdminText.label12(
                            color: AdminColors.primaryBlue,
                            w: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Text(
                    context.t('subAdminNoSpaces'),
                    style: AdminText.label12(
                      color: AdminColors.danger,
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// 🔹 الأزرار
          Column(
            children: [
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    AdminIconMapper.edit(),
                    size: 18,
                    color: AdminColors.primaryBlue,
                  ),
                ),
              ),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.person_remove_outlined,
                    size: 18,
                    color: AdminColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =========================
/// MODELS (UI ONLY)
/// =========================
class _SubAdminItem {
  final String uid;
  final String name;
  final String email;
  final List<String> assignedSpaceIds;
  final List<String> assignedSpaceNames;

  const _SubAdminItem({
    required this.uid,
    required this.name,
    required this.email,
    required this.assignedSpaceIds,
    required this.assignedSpaceNames,
  });
}

class _SpaceOption {
  final String id;
  final String name;

  const _SpaceOption({
    required this.id,
    required this.name,
  });
}
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../_shared/admin_ui.dart';
import '../../../../core/i18n/app_i18n.dart';

/// صفحة إدارة المشرفين الفرعيين — للأدمن الكامل فقط
class SubAdminsPage extends StatefulWidget {
  const SubAdminsPage({super.key});

  static Widget withBloc() => const SubAdminsPage();

  @override
  State<SubAdminsPage> createState() => _SubAdminsPageState();
}

class _SubAdminsPageState extends State<SubAdminsPage> {
  final _db = FirebaseFirestore.instance;
  bool _loading = true;
  List<_SubAdminItem> _items = [];
  List<_SpaceOption> _spaces = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _db.collection('spaces').get(),
        _db.collection('users').where('role', isEqualTo: 'sub_admin').get(),
      ]);

      final spacesSnap = results[0];
      final subAdminsSnap = results[1];

      _spaces = spacesSnap.docs.map((d) {
        final name = d.data()['spaceName'] as String? ?? d.data()['name'] as String? ?? d.id;
        return _SpaceOption(id: d.id, name: name);
      }).toList();

      _items = subAdminsSnap.docs.map((d) {
        final data = d.data();
        final rawIds = data['assignedSpaceIds'];
        final assignedIds = rawIds is List ? rawIds.map((e) => e.toString()).toList() : <String>[];
        final assignedNames = assignedIds.map((id) {
          return _spaces.firstWhere((s) => s.id == id, orElse: () => _SpaceOption(id: id, name: id)).name;
        }).toList();
        return _SubAdminItem(
          uid: d.id,
          name: data['fullName'] as String? ?? data['full_name'] as String? ?? 'Unknown',
          email: data['email'] as String? ?? '',
          assignedSpaceIds: assignedIds,
          assignedSpaceNames: assignedNames,
        );
      }).toList();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _showCreateDialog() async {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final selectedIds = <String>{};
    bool creating = false;
    String? errorMsg;

    await showDialog(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          Future<void> create() async {
            final name = nameCtrl.text.trim();
            final email = emailCtrl.text.trim();
            final pass = passCtrl.text.trim();

            if (name.isEmpty || email.isEmpty || pass.isEmpty) {
              setSt(() => errorMsg = ctx.t('subAdminFillAll'));
              return;
            }
            if (pass.length < 6) {
              setSt(() => errorMsg = ctx.t('passwordLength'));
              return;
            }

            setSt(() { creating = true; errorMsg = null; });
            try {
              // إنشاء حساب جديد بدون تسجيل خروج الأدمن الحالي
              final appName = 'sub_create_${DateTime.now().millisecondsSinceEpoch}';
              final secondaryApp = await Firebase.initializeApp(
                name: appName,
                options: Firebase.app().options,
              );
              try {
                final cred = await FirebaseAuth.instanceFor(app: secondaryApp)
                    .createUserWithEmailAndPassword(email: email, password: pass);
                final uid = cred.user!.uid;
                await _db.collection('users').doc(uid).set({
                  'uid': uid,
                  'email': email,
                  'fullName': name,
                  'role': 'sub_admin',
                  'assignedSpaceIds': selectedIds.toList(),
                  'status': 'active',
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } finally {
                await secondaryApp.delete();
              }

              Navigator.of(ctx).pop();
              _load();
            } catch (e) {
              setSt(() { creating = false; errorMsg = _parseError(e); });
            }
          }

          return AlertDialog(
            backgroundColor: AdminColors.bg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(ctx.t('subAdminCreate'), style: AdminText.h2()),
            content: SizedBox(
              width: 320,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DialogField(ctrl: nameCtrl, hint: ctx.t('subAdminNameHint'), label: ctx.t('subAdminNameLabel')),
                    const SizedBox(height: 10),
                    _DialogField(ctrl: emailCtrl, hint: 'email@example.com', label: ctx.t('email'), keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    _DialogField(ctrl: passCtrl, hint: ctx.t('subAdminPasswordHint'), label: ctx.t('password'), obscure: true),
                    if (errorMsg != null) ...[
                      const SizedBox(height: 8),
                      Text(errorMsg!, style: AdminText.label12(color: AdminColors.danger)),
                    ],
                    const SizedBox(height: 16),
                    Text(ctx.t('subAdminAssignSpaces'), style: AdminText.body14(w: FontWeight.w600, color: AdminColors.text)),
                    const SizedBox(height: 8),
                    ..._spaces.map((s) {
                      final checked = selectedIds.contains(s.id);
                      return InkWell(
                        onTap: () => setSt(() {
                          if (checked) selectedIds.remove(s.id);
                          else selectedIds.add(s.id);
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(
                                checked ? Icons.check_box : Icons.check_box_outline_blank,
                                size: 20,
                                color: checked ? AdminColors.primaryBlue : AdminColors.black40,
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(s.name, style: AdminText.body14(color: AdminColors.text))),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(ctx.t('cancel'), style: AdminText.body14(color: AdminColors.black40)),
              ),
              TextButton(
                onPressed: creating ? null : create,
                child: creating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(ctx.t('subAdminCreate'), style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _showEditDialog(_SubAdminItem item) async {
    final selectedIds = item.assignedSpaceIds.toSet();

    await showDialog(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          Future<void> save() async {
            try {
              await _db.collection('users').doc(item.uid).update({
                'assignedSpaceIds': selectedIds.toList(),
              });
              Navigator.of(ctx).pop();
              _load();
            } catch (_) {}
          }

          return AlertDialog(
            backgroundColor: AdminColors.bg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(ctx.t('subAdminEdit'), style: AdminText.h2()),
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AdminText.body16(w: FontWeight.w700)),
                  Text(item.email, style: AdminText.body14()),
                  const SizedBox(height: 16),
                  Text(ctx.t('subAdminAssignedSpaces'), style: AdminText.body14(w: FontWeight.w600, color: AdminColors.text)),
                  const SizedBox(height: 8),
                  ..._spaces.map((s) {
                    final checked = selectedIds.contains(s.id);
                    return InkWell(
                      onTap: () => setSt(() {
                        if (checked) selectedIds.remove(s.id);
                        else selectedIds.add(s.id);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              checked ? Icons.check_box : Icons.check_box_outline_blank,
                              size: 20,
                              color: checked ? AdminColors.primaryBlue : AdminColors.black40,
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(s.name, style: AdminText.body14(color: AdminColors.text))),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(ctx.t('cancel'), style: AdminText.body14(color: AdminColors.black40)),
              ),
              TextButton(
                onPressed: save,
                child: Text(ctx.t('save'), style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _removeSubAdmin(_SubAdminItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.t('subAdminRemove'), style: AdminText.h2()),
        content: Text('${context.t('subAdminRemove')}: ${item.name}?', style: AdminText.body14(color: AdminColors.text)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.t('cancel'), style: AdminText.body14())),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.t('adminDelete'), style: AdminText.body14(color: AdminColors.danger, w: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.collection('users').doc(item.uid).update({
          'role': 'user',
          'assignedSpaceIds': [],
        });
        _load();
      } catch (_) {}
    }
  }

  String _parseError(Object e) {
    if (e is FirebaseAuthException) {
      return switch (e.code) {
        'email-already-in-use' => 'This email is already registered',
        'invalid-email' => 'Invalid email address',
        'weak-password' => 'Password too weak (min 6 chars)',
        _ => 'Error: ${e.message}',
      };
    }
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      floatingActionButton: FloatingActionButton(
        heroTag: 'sub_admins_fab',
        backgroundColor: AdminColors.primaryAmber,
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminAppBar(title: context.t('subAdminsTitle'), subtitle: context.t('subAdminsSubtitle')),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                      child: Center(child: Text(context.t('subAdminsNoItems'), style: AdminText.body14())),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _SubAdminCard(
                          item: _items[i],
                          onEdit: () => _showEditDialog(_items[i]),
                          onRemove: () => _removeSubAdmin(_items[i]),
                        ),
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
}

class _DialogField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _DialogField({required this.ctrl, required this.label, required this.hint, this.obscure = false, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AdminText.label12(color: AdminColors.black75, w: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AdminColors.black15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: ctrl,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: AdminText.body14(color: AdminColors.text),
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: AdminText.body14(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubAdminCard extends StatelessWidget {
  final _SubAdminItem item;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _SubAdminCard({required this.item, required this.onEdit, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AdminColors.primaryBlue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
              style: AdminText.body16(color: AdminColors.primaryBlue, w: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
                Text(item.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14()),
                if (item.assignedSpaceNames.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: item.assignedSpaceNames.map((name) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AdminColors.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(name, style: AdminText.label12(color: AdminColors.primaryBlue, w: FontWeight.w500)),
                    )).toList(),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Text(context.t('subAdminNoSpaces'), style: AdminText.label12(color: AdminColors.danger)),
                ],
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(AdminIconMapper.edit(), size: 18, color: AdminColors.primaryBlue),
                ),
              ),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.person_remove_outlined, size: 18, color: AdminColors.danger),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubAdminItem {
  final String uid;
  final String name;
  final String email;
  final List<String> assignedSpaceIds;
  final List<String> assignedSpaceNames;

  const _SubAdminItem({
    required this.uid,
    required this.name,
    required this.email,
    required this.assignedSpaceIds,
    required this.assignedSpaceNames,
  });
}

class _SpaceOption {
  final String id;
  final String name;
  const _SpaceOption({required this.id, required this.name});
}
*/
