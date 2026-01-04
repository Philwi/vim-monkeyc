using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Sensor;
using Toybox.Position;
using Toybox.Math;
using Toybox.Timer;

//! SurfTracker - Wave detection and session tracking for Garmin watches
//! Uses accelerometer data combined with GPS speed validation
//! to accurately count waves during a surf session.

(:glance)
module SurfTracker {
    const VERSION = "1.0.0";
    const MIN_WAVE_SPEED = 11.0;    // km/h - minimum speed to count as riding
    const COOLDOWN_SECONDS = 20;     // seconds between wave detections
    const GPS_WARMUP_TIME = 30000;   // 30 seconds in milliseconds
}

(:standard_memory)
class WaveDetector extends WatchUi.BehaviorDelegate {
    enum WaveState {
        STATE_IDLE,
        STATE_PADDLING,
        STATE_RIDING,
        STATE_COOLDOWN
    }

    private var _waveCount as Number = 0;
    private var _currentState as WaveState = STATE_IDLE;
    private var _lastWaveTime as Number = 0;
    private var _gpsReady as Boolean = false;
    private var _sessionActive as Boolean = false;

    private var _accelData as Array<Float>?;
    private var _speedHistory as Dictionary<Number, Float>;

    //! Initialize the wave detector with default settings
    function initialize() {
        BehaviorDelegate.initialize();
        _speedHistory = {};
        _accelData = new Array<Float>[100];
        resetSession();
    }

    //! Start a new surf session
    //! @param options Session configuration options
    //! @return true if session started successfully
    function startSession(options as Dictionary?) as Boolean {
        if (_sessionActive) {
            return false;
        }

        _sessionActive = true;
        _waveCount = 0;
        _currentState = STATE_IDLE;

        // Enable sensors
        Sensor.setEnabledSensors([Sensor.SENSOR_ACCELEROMETER]);
        Sensor.enableSensorEvents(method(:onSensorData));

        Position.enableLocationEvents(
            Position.LOCATION_CONTINUOUS,
            method(:onPosition)
        );

        System.println("Session started at " + Time.now().value());
        return true;
    }

    //! Process incoming accelerometer data
    function onSensorData(info as Sensor.Info) as Void {
        if (!_sessionActive or info == null) {
            return;
        }

        var accel = info.accel;
        if (accel == null) {
            return;
        }

        // Calculate total G-force magnitude
        var gForce = Math.sqrt(
            accel[0] * accel[0] +
            accel[1] * accel[1] +
            accel[2] * accel[2]
        ) / 9.81;

        detectWavePattern(gForce);
    }

    //! GPS position callback
    function onPosition(info as Position.Info) as Void {
        if (info.accuracy < Position.QUALITY_USABLE) {
            _gpsReady = false;
            return;
        }

        _gpsReady = true;
        var speed = info.speed * 3.6; // Convert m/s to km/h

        if (_currentState == STATE_RIDING and speed < SurfTracker.MIN_WAVE_SPEED) {
            endWaveRide();
        }
    }

    //! Analyze G-force pattern to detect wave rides
    private function detectWavePattern(gForce as Float) as Void {
        /* 
         * Wave detection algorithm:
         * 1. Check for initial acceleration spike (takeoff)
         * 2. Validate with GPS speed
         * 3. Monitor for sustained riding pattern
         * 4. Detect wave end via speed/acceleration drop
         */

        if (!_gpsReady) {
            return; // GPS required for validation
        }

        var now = System.getTimer();

        switch (_currentState) {
            case STATE_IDLE:
                if (gForce > 1.8 and canStartNewWave(now)) {
                    _currentState = STATE_RIDING;
                    _lastWaveTime = now;
                }
                break;

            case STATE_RIDING:
                if (gForce < 0.5 or hasRideTimedOut(now)) {
                    endWaveRide();
                }
                break;

            case STATE_COOLDOWN:
                if (now - _lastWaveTime > SurfTracker.COOLDOWN_SECONDS * 1000) {
                    _currentState = STATE_IDLE;
                }
                break;
        }
    }

    private function canStartNewWave(timestamp as Number) as Boolean {
        return timestamp - _lastWaveTime > SurfTracker.COOLDOWN_SECONDS * 1000;
    }

    private function hasRideTimedOut(timestamp as Number) as Boolean {
        return timestamp - _lastWaveTime > 45000; // 45 second max ride
    }

    private function endWaveRide() as Void {
        _waveCount++;
        _currentState = STATE_COOLDOWN;

        // TODO: Add vibration feedback
        if (Attention has :vibrate) {
            Attention.vibrate([new Attention.VibeProfile(50, 200)]);
        }
    }

    private function resetSession() as Void {
        _waveCount = 0;
        _currentState = STATE_IDLE;
        _lastWaveTime = 0;
        _gpsReady = false;
        _sessionActive = false;
    }

    //! Get current wave count
    function getWaveCount() as Number {
        return _waveCount;
    }

    //! Check if GPS is ready for tracking
    function isGpsReady() as Boolean {
        return _gpsReady;
    }
}
