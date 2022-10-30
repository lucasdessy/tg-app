import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sales_platform_app/application/user/user_view_model.dart';
import 'package:sales_platform_app/presentation/shared/widgets/input_field.dart';

import '../../shared/config.dart';

class MiniProfile extends StatefulWidget {
  final void Function(String?) onEditPressed;
  final VoidCallback? onProfilePressed;
  final bool editing;
  final UserViewModel? user;
  const MiniProfile(
      {required this.onEditPressed,
      required this.onProfilePressed,
      this.editing = false,
      required this.user,
      Key? key})
      : super(key: key);

  @override
  State<MiniProfile> createState() => _MiniProfileState();
}

class _MiniProfileState extends State<MiniProfile> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.user?.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onProfilePressed,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: SharedConfigs.colors.tertiary,
            backgroundImage: (widget.user?.profileImageUrl != null &&
                    widget.user!.profileImageUrl!.isNotEmpty
                ? CachedNetworkImageProvider(widget.user!.profileImageUrl!)
                : AssetImage(SharedConfigs.noUserImage()) as ImageProvider),
            child: widget.editing
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: SharedConfigs.colors.neutral,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.editing
                ? Expanded(
                    child: AppInputField(
                      fillColor: SharedConfigs.colors.tertiary,
                      controller: _controller,
                      textColor: SharedConfigs.colors.neutral,
                    ),
                  )
                : Text(
                    "${widget.user?.name}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            IconButton(
              onPressed: () => widget.onEditPressed(_controller.text),
              icon: Icon(
                widget.editing ? Icons.check : Icons.edit,
                color: SharedConfigs.colors.neutral,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text("${widget.user?.address.state} - ${widget.user?.address.city}"),
      ],
    );
  }
}
