import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CompletingAnimation extends SimpleAnimation {
  CompletingAnimation(String animationName, {double mix})
      : super(animationName, mix: mix);

  /// Tracks whether the animation should enter a paused state at the end of the
  /// current animation cycle
  bool _pause = false;
  bool get pause => _pause;
  set pause(bool value) {
    _pause = value;
    // Start immediately if unpaused
    if (!value) {
      isActive = true;
    }
  }

  /// Pauses at the end of an animation loop if _pause is true
  void _pauseAtEndOfAnimation() {
    // Calculate the start time of the animation, which may not be 0 if work
    // area is enabled
    final start =
        instance.animation.enableWorkArea ? instance.animation.workStart : 0;
    // Calculate the frame the animation is currently on
    final currentFrame = ((instance.time - start) * instance.animation.fps);
    // If the animation is within the window of a single frame, pause
    if (currentFrame <= 1) {
      isActive = false;
    }
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    // Apply the animation to the artboard with the appropriate level of mix
    instance.animation.apply(instance.time, coreContext: artboard, mix: mix);

    // If pause has been requested, try to pause
    if (_pause) {
      _pauseAtEndOfAnimation();
    }

    // If false, the animation has ended (it doesn't loop)
    if (!instance.advance(elapsedSeconds)) {
      isActive = false;
    }
  }
}
