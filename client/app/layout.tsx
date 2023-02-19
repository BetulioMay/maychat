import "./globals.css";
import type { ReactNode } from "react";
import { Roboto } from "@next/font/google";

const font = Roboto({
  weight: "400",
  subsets: ["latin"],
});

interface RootLayoutProps {
  children: ReactNode;
}

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html className="dark transition-colors" lang="en">
      {/*
        <head /> will contain the components returned by the nearest parent
        head.tsx. Find out more at https://beta.nextjs.org/docs/api-reference/file-conventions/head
      */}
      <head />
      <body className="bg-white dark:bg-slate-800">
        <main className={font.className}>{children}</main>
      </body>
    </html>
  );
}
