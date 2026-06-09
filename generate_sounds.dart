import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() async {
  final outDir = Directory('assets/sounds');
  if (!await outDir.exists()) {
    await outDir.create(recursive: true);
  }

  // Generate a high pitch "success" beep for Check In (e.g., 880 Hz, 150ms)
  await _generateBeep(File('assets/sounds/check_in.wav'), 880, 0.15);

  // Generate a lower pitch "dong" beep for Check Out (e.g., 440 Hz, 150ms)
  await _generateBeep(File('assets/sounds/check_out.wav'), 440, 0.15);

  print('Sounds generated successfully.');
}

Future<void> _generateBeep(File file, double frequency, double durationSeconds) async {
  final sampleRate = 44100;
  final numSamples = (sampleRate * durationSeconds).round();
  final byteRate = sampleRate * 2; // 16-bit mono

  final header = BytesBuilder();
  
  // RIFF header
  header.add('RIFF'.codeUnits);
  header.add(_int32ToBytes(36 + numSamples * 2)); // file size - 8
  header.add('WAVE'.codeUnits);

  // fmt chunk
  header.add('fmt '.codeUnits);
  header.add(_int32ToBytes(16)); // chunk size
  header.add(_int16ToBytes(1)); // PCM format
  header.add(_int16ToBytes(1)); // 1 channel
  header.add(_int32ToBytes(sampleRate));
  header.add(_int32ToBytes(byteRate));
  header.add(_int16ToBytes(2)); // block align
  header.add(_int16ToBytes(16)); // bits per sample

  // data chunk
  header.add('data'.codeUnits);
  header.add(_int32ToBytes(numSamples * 2));

  final data = BytesBuilder();
  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    // Apply a simple envelope to prevent clicking (fade out)
    final envelope = 1.0 - (i / numSamples);
    final sample = sin(2 * pi * frequency * t) * envelope;
    final intSample = (sample * 32767).round().clamp(-32768, 32767);
    data.add(_int16ToBytes(intSample));
  }

  final finalBytes = header.toBytes() + data.toBytes();
  await file.writeAsBytes(finalBytes);
}

List<int> _int16ToBytes(int value) {
  return [value & 0xff, (value >> 8) & 0xff];
}

List<int> _int32ToBytes(int value) {
  return [
    value & 0xff,
    (value >> 8) & 0xff,
    (value >> 16) & 0xff,
    (value >> 24) & 0xff
  ];
}
