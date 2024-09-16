const std = @import("std");
const rl = @import("raylib");

const Bullet = @import("bullet.zig").Bullet;
const Arrow = @import("arrow.zig").Arrow;

const allocator = std.heap.page_allocator;

pub fn main() anyerror!void {
    rl.initWindow(800, 450, "game!!");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    const arrow_texture = rl.loadTexture("assets/tile_0071.png");
    const arrow_pos = rl.Vector2.init(
        @floatFromInt(@divExact(rl.getScreenWidth(), 2)),
        @floatFromInt(@divExact(rl.getScreenHeight(), 2)),
    );
    var arrow = Arrow.new(arrow_pos, arrow_texture);

    var bullets = std.ArrayList(Bullet).init(allocator);
    defer bullets.deinit();

    // Main game loop
    while (!rl.windowShouldClose()) {
        // keys
        if (rl.isKeyDown(rl.KeyboardKey.key_w) and arrow_pos.y > 30) arrow.position.y -= 6;
        if (rl.isKeyDown(rl.KeyboardKey.key_a)) arrow.position.x -= 6;
        if (rl.isKeyDown(rl.KeyboardKey.key_s)) arrow.position.y += 6;
        if (rl.isKeyDown(rl.KeyboardKey.key_d)) arrow.position.x += 6;

        // update
        arrow.update();
        for (bullets.items) |*bullet| bullet.update();

        // draw
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.dark_blue);

        if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left))
            try bullets.append(Bullet.new(arrow.position));

        for (bullets.items, 0..) |*bullet, i| {
            if (bullets.items.len == i) break;
            bullet.draw();
            if (bullet.is_out_of_window()) _ = bullets.orderedRemove(i);
        }
        arrow.draw();

        var buf: [255]u8 = undefined;
        rl.drawText("Debug info:", 20, 20, 15, rl.Color.black);
        rl.drawText(try std.fmt.bufPrintZ(&buf, "fps: {d}", .{rl.getFPS()}), 20, 40, 10, rl.Color.black);
        rl.drawText(try std.fmt.bufPrintZ(&buf, "bullet count: {d}", .{bullets.items.len}), 20, 50, 10, rl.Color.black);
    }
}
