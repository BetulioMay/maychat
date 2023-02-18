import React from "react";

interface RegisterLayoutProps {
  children: React.ReactNode;
}

const RegisterLayout: React.FC<RegisterLayoutProps> = ({ children }) => {
  return (
    <section className="flex min-h-screen items-center justify-center bg-white">
      <div>{children}</div>
    </section>
  );
};

export default RegisterLayout;
