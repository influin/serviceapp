import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TagsInputWidget extends StatefulWidget {
  final List<String> tags;
  final Function(String) onTagAdded;
  final Function(String) onTagRemoved;
  final int maxTags;
  final String title;
  final String? subtitle;

  const TagsInputWidget({
    Key? key,
    required this.tags,
    required this.onTagAdded,
    required this.onTagRemoved,
    required this.maxTags,
    this.title = 'Tags',
    this.subtitle,
  }) : super(key: key);

  @override
  State<TagsInputWidget> createState() => _TagsInputWidgetState();
}

class _TagsInputWidgetState extends State<TagsInputWidget> {
  final TextEditingController _tagController = TextEditingController();

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !widget.tags.contains(tag) && widget.tags.length < widget.maxTags) {
      widget.onTagAdded(tag);
      _tagController.clear();
    } else if (widget.tags.length >= widget.maxTags) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum ${widget.maxTags} tags allowed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: theme.titleStyle),
        if (widget.subtitle != null) ...[  
          const SizedBox(height: 4),
          Text(
            widget.subtitle!,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: theme.inputDecoration(
                  labelText: 'Enter a tag',
                  prefixIcon: Icons.tag,
                  context: context,
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: widget.tags.length < widget.maxTags ? _addTag : null,
              style: theme.primaryButtonStyle(context).copyWith(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  const Size(0, 0),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        if (widget.tags.isNotEmpty) const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => widget.onTagRemoved(tag),
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
        if (widget.tags.isNotEmpty) ...[  
          const SizedBox(height: 8),
          Text(
            '${widget.tags.length}/${widget.maxTags} tags',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ],
    );
  }
}