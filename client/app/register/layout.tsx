import React, { Suspense } from "react";
import Loading from "./loading";

interface RegisterLayoutProps {
  children: React.ReactNode;
}

const RegisterLayout: React.FC<RegisterLayoutProps> = ({ children }) => {
  return (
    <Suspense fallback={<Loading />}>
      <section className="flex min-h-screen items-center justify-center">
        <div>{children}</div>
      </section>
    </Suspense>
  );
};

export default RegisterLayout;
