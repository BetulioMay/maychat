import React from "react";

interface LoginLayoutProps {
  children: React.ReactNode;
}

const LoginLayout: React.FC<LoginLayoutProps> = ({ children }) => {
  return (
    <section className="flex min-h-screen items-center justify-center bg-white">
      <div>{children}</div>
    </section>
  );
};

export default LoginLayout;
