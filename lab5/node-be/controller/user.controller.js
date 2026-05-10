const UserServices = require('../services/user.service');

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const duplicate = await UserServices.getUserByEmail(email);
        if (duplicate) {
            return res.status(400).json({ 
                status: false, 
                message: `Email ${email} đã được đăng ký` 
            });
        }
        const response = await UserServices.registerUser(email, password);
        res.json({ 
            status: true, 
            message: 'Đăng ký thành công!' 
        });
    } catch (err) {
        res.status(500).json({ 
            status: false, 
            message: 'Lỗi server: ' + err.message 
        });
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ 
                status: false, 
                message: 'Vui lòng nhập đầy đủ email và mật khẩu' 
            });
        }
        let user = await UserServices.checkUser(email);
        if (!user) {
            return res.status(400).json({ 
                status: false, 
                message: 'Email không tồn tại' 
            });
        }
        const isPasswordCorrect = await user.comparePassword(password);
        if (isPasswordCorrect === false) {
            return res.status(400).json({ 
                status: false, 
                message: 'Mật khẩu không đúng' 
            });
        }
        // Tạo JWT Token
        let tokenData = { _id: user._id, email: user.email };
        const token = await UserServices.generateAccessToken(tokenData, "secret", "1h");
        res.status(200).json({ 
            status: true, 
            message: "Đăng nhập thành công", 
            token: token 
        });
    } catch (error) {
        res.status(500).json({ 
            status: false, 
            message: 'Lỗi server: ' + error.message 
        });
    }
}