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
          activeColor: Color.fromRGBO(247, 255, 247, 1),
          activeTrackColor: Color.fromRGBO(156, 146, 163, 0.5),
          inactiveThumbColor:  Color.fromRGBO(156, 146, 163, 1),
          inactiveTrackColor: Color.fromRGBO(59, 65, 73, 0.5),
          title: const Text('Power', style: TextStyle(color: Color.fromRGBO(247, 255, 217, 1)),),
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
            activeColor: const Color.fromRGBO(78, 205, 196, 1),
            inactiveColor: const Color.fromARGB(126, 155, 203, 200),
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
            activeColor: const Color.fromRGBO(78, 205, 196, 1),
            inactiveColor: const Color.fromARGB(126, 155, 203, 200),
          label: 'Volume $volume',
          onChanged: (newVolume) {
            onVolumeChange?.call(newVolume.toInt());
          },
        ),
      ],
    );
  }
}
