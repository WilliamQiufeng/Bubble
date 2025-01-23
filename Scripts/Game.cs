using Godot;

namespace Bubble;

public partial class Game : Node
{
    private float _gameSpeed = 1;
    public static Game Instance { get; private set; }
    public override void _EnterTree()
    {
        base._EnterTree();
        Instance = this;
    }

    public override void _ExitTree()
    {
        base._ExitTree();
        Instance = null;
    }

    [Export]
    public float GameSpeed
    {
        get => _gameSpeed;
        set
        {
            _gameSpeed = value;
            EmitSignal(SignalName.GameSpeedChange, value);
        }
    }

    [Signal]
    public delegate void GameSpeedChangeEventHandler(float newSpeed);

    public void SetTheWorld(bool active)
    {
        GameSpeed = active ? 0.5f : 1;
    }
}