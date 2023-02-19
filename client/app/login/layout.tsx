import React, { Suspense } from "react";
import Loading from "./loading";

interface LoginLayoutProps {
  children: React.ReactNode;
}

const LoginLayout: React.FC<LoginLayoutProps> = ({ children }) => {
  return (
    <Suspense fallback={<Loading />}>
      <section className="flex min-h-screen items-center justify-center bg-white">
        <div>{children}</div>
      </section>
    </Suspense>
  );
};

export default LoginLayout;
