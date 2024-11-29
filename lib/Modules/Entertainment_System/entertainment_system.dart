import 'package:flutter/material.dart';

class EntertainmentSystemWidget extends StatelessWidget {
  final bool isOn;
  final int channel;
  final int volume;
  final ValueChanged<bool>? onPowerChange;
  final ValueChanged<int>? onChannelChange;
  final ValueChanged<int>? onVolumeChange;

  const EntertainmentSystemWidget({
    Key? key,
    required this.isOn,
    required this.channel,
    required this.volume,
    this.onPowerChange,
    this.onChannelChange,
    this.onVolumeChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Power'),
          value: isOn,
          onChanged: (newValue) {
            onPowerChange?.call(newValue);
          },
        ),
        Slider(
          value: channel.toDouble(),
          min: 1,
          max: 100,
          divisions: 100,
          label: 'Channel $channel',
          onChanged: (newChannel) {
            onChannelChange?.call(newChannel.toInt());
          },
        ),
        Slider(
          value: volume.toDouble(),
          min: 0,
          max: 100,
          divisions: 100,
          label: 'Volume $volume',
          onChanged: (newVolume) {
            onVolumeChange?.call(newVolume.toInt());
          },
        ),
      ],
    );
  }
}
