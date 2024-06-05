local function toggle_anime_shaders()
    mp.command('change-list glsl-shaders toggle "~/.config/mpv/shaders/anime7k/Anime4K_Clamp_Highlights.glsl"')
    mp.command('change-list glsl-shaders toggle "~/.config/mpv/shaders/anime4k/Anime4K_Restore_CNN_VL.glsl"')
    mp.command('change-list glsl-shaders toggle "~/.config/mpv/shaders/anime4k/Anime4K_Upscale_CNN_x2_VL"')
    mp.command('change-list glsl-shaders toggle "~/.config/mpv/shaders/anime4k/Anime4K_AutoDownscalePre_x2.glsl"')
    mp.command('change-list glsl-shaders toggle "~/.config/mpv/shaders/anime4k/Anime4K_AutoDownscalePre_x4.glsl"')
    mp.command('change-list glsl-shaders toggle "~/.config/mpv/shaders/anime4k/Anime4K_Upscale_CNN_x2_M.glsl"')
end

mp.add_key_binding("Ctrl+1", "toggle-anime-shaders", toggle_anime_shaders)
