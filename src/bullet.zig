const std = @import("std");
const rl = @import("raylib");

pub const Bullet = struct {
    position: rl.Vector2,
    rotation: f32,
    speed: f32 = 3,

    pub fn new(position: rl.Vector2) Bullet {
        const mouse_pos = rl.getMousePosition();
        const rotate_deg = (std.math.atan2(mouse_pos.x - position.x, mouse_pos.y - position.y) * -57.2957);
        return Bullet{
            .position = position,
            .rotation = rotate_deg + 90,
        };
    }

    pub fn update(self: *Bullet) void {
        const radians = self.rotation * std.math.rad_per_deg;
        const dX = self.speed * std.math.cos(radians);
        const dY = self.speed * std.math.sin(radians);
        self.position.x += dX;
        self.position.y += dY;
    }

    pub fn draw(self: *Bullet) void {
        const rect = rl.Rectangle.init(self.position.x, self.position.y, 5, 25);
        rl.drawRectanglePro(rect, rl.Vector2.init(2.5, 12.5), self.rotation + 90, rl.Color.red);
    }

    pub fn is_out_of_window(self: *Bullet) bool {
        if (self.position.x < -50) return true;
        if (self.position.x - 50 > @as(f32, @floatFromInt(rl.getScreenWidth()))) return true;

        if (self.position.y < -50) return true;
        if (self.position.y - 50 > @as(f32, @floatFromInt(rl.getScreenHeight()))) return true;

        return false;
    }
};
