const std = @import("std");
const rl = @import("raylib");

pub const Arrow = struct {
    position: rl.Vector2,
    texture: rl.Texture,
    rotation: f32 = 0,
    speed: f32 = 3,

    pub fn new(position: rl.Vector2, texture: rl.Texture) Arrow {
        return Arrow{ .position = position, .texture = texture };
    }

    pub fn update(self: *Arrow) void {
        const mouse_pos = rl.getMousePosition();
        self.rotation = std.math.atan2(mouse_pos.x - self.position.x, mouse_pos.y - self.position.y) * -57.2957;
    }

    pub fn draw(self: *Arrow) void {
        rl.drawTexturePro(
            self.texture,
            rl.Rectangle.init(0, 0, 16, 16),
            rl.Rectangle.init(self.position.x, self.position.y, 30, 30),
            rl.Vector2.init(15, 15),
            self.rotation,
            rl.Color.yellow,
        );
    }
};
