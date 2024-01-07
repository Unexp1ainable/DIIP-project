function coinId = determineCoin(diameter)
    e2 = 25.75;
    e1 = 23.25;
    c50 = 24.25;
    c20 = 22.25;
    c10 = 19.75;
    c5 = 21.25;

    diameters = [e2, e1, c50, c20, c10, c5];

    [~, index] = min(abs(diameters - diameter));
    coinId = index;
end
